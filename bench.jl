#!/usr/bin/env julia
#
# Benchmark logp + gradient evaluation for Turing vs Stan on PosteriorDB models.
#
# Usage:
#   julia --project=. bench.jl                                           # all models
#   julia --project=. bench.jl eight_schools-eight_schools_centered      # single model
#   julia --project=. bench.jl --eval-only                               # skip gradients
#
# From the REPL:
#   include("bench.jl")
#   ARGS = ["sblri-blr"]; include("bench.jl")

using Printf, Random, LinearAlgebra
using Chairmarks: @be
using Statistics: median
using Turing
using ADTypes: AutoForwardDiff, AutoEnzyme, AutoMooncake
using Enzyme: Reverse, set_runtime_activity
import Mooncake
import LogDensityProblems
using DynamicPPL: LogDensityFunction, VarInfo, link!!

using BridgeStan
using JSON3
using PosteriorDB

# ── PosteriorDB setup ──

POSTERIORDB_PATH = joinpath(dirname(@__DIR__), "posteriordb", "posterior_database")
PDB = PosteriorDB.database(POSTERIORDB_PATH)

# ── Helpers ──

function fmt_time(t)
    isnan(t) && return "—"
    isinf(t) && return "—"
    t === nothing && return "—"
    if t < 1e-6
        @sprintf("%.1f ns", t * 1e9)
    elseif t < 1e-3
        @sprintf("%.1f μs", t * 1e6)
    elseif t < 1.0
        @sprintf("%.2f ms", t * 1e3)
    else
        @sprintf("%.3f s", t)
    end
end

median_time(bench) = median(bench).time

function abbreviate(name)
    function shorten(part)
        words = split(part, '_')
        length(words) == 1 ? part : join(first.(words))
    end
    join(shorten.(split(name, '-')), "-")
end

AD_BACKENDS = [
    ("FD", AutoForwardDiff()),
    ("Ez", AutoEnzyme(; mode=set_runtime_activity(Reverse))),
    ("Mc", AutoMooncake()),
]

function bench_turing(turing_model, model_name; eval_only=false)
    rng = Xoshiro(468)
    vi = VarInfo(rng, turing_model)
    vi = link!!(vi, turing_model)
    params = vi[:]


    fd_ldf = LogDensityFunction(turing_model, vi; adtype=AutoForwardDiff())

    LogDensityProblems.logdensity(fd_ldf, params) # warmup
    primal_time = median_time(@be LogDensityProblems.logdensity($fd_ldf, $params))

    LogDensityProblems.logdensity_and_gradient(fd_ldf, params) # warmup
    fd_grad_time = median_time(@be LogDensityProblems.logdensity_and_gradient($fd_ldf, $params))
    grad_times = Dict("FD" => fd_grad_time)

    if !eval_only
        for (label, adtype) in AD_BACKENDS
            label == "FD" && continue
            try
                ad_ldf = LogDensityFunction(turing_model, vi; adtype=adtype)
                LogDensityProblems.logdensity_and_gradient(ad_ldf, params) # warmup
                result = median_time(@be LogDensityProblems.logdensity_and_gradient($ad_ldf, $params))
                grad_times[label] = result
            catch e
                @warn "$model_name: $label failed — $(typeof(e))"
                grad_times[label] = Inf
            end
        end
    end

    return (primal_time=primal_time, grad_times=grad_times, dim=length(params))
end

# ── Discover models ──

MODEL_DIR = joinpath(@__DIR__, "models")
EVAL_ONLY = "--eval-only" in ARGS
args = filter(a -> !startswith(a, "--"), ARGS)

if isempty(args)
    models = sort!([replace(f, ".jl" => "") for f in readdir(MODEL_DIR) if endswith(f, ".jl")])
else
    models = args
end

println("Running $(length(models)) model(s).")
for m in models
    println("  - $m")
end
println()

# ── Results ──

struct Result
    name::String
    dim::Int
    turing_primal::Float64
    stan_primal::Float64
    turing_fd_grad::Float64
    turing_enzyme_grad::Float64
    turing_mooncake_grad::Float64
    stan_grad::Float64
end

results = Result[]

for model_name in models
    println("Running: $model_name ...")

    # ── Load data from PosteriorDB ──
    post = PosteriorDB.posterior(PDB, model_name)
    pdb_dataset = PosteriorDB.dataset(post)
    data = PosteriorDB.load(pdb_dataset)

    # ── Turing ──
    include(joinpath(MODEL_DIR, model_name * ".jl"))
    turing_model = make_model(Val(Symbol(model_name)), data)
    turing = bench_turing(turing_model, model_name; eval_only=EVAL_ONLY)

    # ── Stan ──
    pdb_model = PosteriorDB.model(post)
    stan_impl = PosteriorDB.implementation(pdb_model, "stan")
    stan_file = PosteriorDB.path(stan_impl)
    stan_data_json = PosteriorDB.load(pdb_dataset, String)

    sm = BridgeStan.StanModel(stan_file, stan_data_json, 468)
    d = Int(BridgeStan.param_unc_num(sm))
    q = randn(Xoshiro(468), d)

    BridgeStan.log_density(sm, q; propto=false)
    t_stan_primal = median_time(@be BridgeStan.log_density($sm, $q; propto=false))

    t_stan_grad = NaN
    if !EVAL_ONLY
        BridgeStan.log_density_gradient(sm, q; propto=false)
        t_stan_grad = median_time(@be BridgeStan.log_density_gradient($sm, $q; propto=false))
    end

    push!(results, Result(
        model_name, turing.dim,
        turing.primal_time, t_stan_primal,
        get(turing.grad_times, "FD", NaN),
        get(turing.grad_times, "Ez", NaN),
        get(turing.grad_times, "Mc", NaN),
        t_stan_grad,
    ))
end

# ── Table ──

col = 11
name_w = max(16, maximum(length(abbreviate(r.name)) for r in results) + 1)
pre = name_w + 4

eval_cols = ["Turing", "Stan"]
grad_cols = ["FwdDiff", "Enzyme", "Mooncake", "Stan"]
eval_w = length(eval_cols) * col
grad_w = length(grad_cols) * col
gap = "  "
total_w = pre + length(gap) + eval_w + (EVAL_ONLY ? 0 : length(gap) + grad_w)

println()
println("=" ^ total_w)

eval_label = "eval"
grad_label = "gradient"
group = rpad("", pre) * gap *
    rpad(" " ^ max(0, div(eval_w - length(eval_label), 2)) * eval_label, eval_w) *
    (EVAL_ONLY ? "" : gap * rpad(" " ^ max(0, div(grad_w - length(grad_label), 2)) * grad_label, grad_w))
println(group)

uline = rpad("", pre) * gap * "-" ^ eval_w *
    (EVAL_ONLY ? "" : gap * "-" ^ grad_w)
println(uline)

header = rpad("Model", name_w) * lpad("dim", 4) * gap *
    join(lpad(h, col) for h in eval_cols) *
    (EVAL_ONLY ? "" : gap * join(lpad(h, col) for h in grad_cols))
println(header)
println("-" ^ total_w)

for r in results
    row = rpad(abbreviate(r.name), name_w) *
        lpad(string(r.dim), 4) * gap *
        lpad(fmt_time(r.turing_primal), col) *
        lpad(fmt_time(r.stan_primal), col) *
        (EVAL_ONLY ? "" : gap *
            lpad(fmt_time(r.turing_fd_grad), col) *
            lpad(fmt_time(r.turing_enzyme_grad), col) *
            lpad(fmt_time(r.turing_mooncake_grad), col) *
            lpad(fmt_time(r.stan_grad), col))
    println(row)
end

println("=" ^ total_w)
