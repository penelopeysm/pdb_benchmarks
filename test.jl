#!/usr/bin/env julia
#
# Test Turing model implementations against PosteriorDB reference posteriors.
#
# Usage:
#   julia --project=. test.jl                                           # all models
#   julia --project=. test.jl eight_schools-eight_schools_noncentered   # single model

using Test, Statistics, Random
using Turing, DynamicPPL
using FlexiChains
using PosteriorDB

POSTERIORDB_PATH = joinpath(dirname(@__DIR__), "posteriordb", "posterior_database")
PDB = PosteriorDB.database(POSTERIORDB_PATH)
MODEL_DIR = joinpath(@__DIR__, "models")

args = filter(a -> !startswith(a, "--"), ARGS)
if isempty(args)
    model_names = sort!([replace(f, ".jl" => "") for f in readdir(MODEL_DIR) if endswith(f, ".jl")])
else
    model_names = args
end

# Map from posterior name to list of (ref_key, turing_varname) pairs
PARAM_MAPS = Dict(
    "eight_schools-eight_schools_centered" => [
        ("mu", @varname(mu)),
        ("tau", @varname(tau)),
        [("theta[$i]", @varname(theta[i])) for i in 1:8]...,
    ],
    "eight_schools-eight_schools_noncentered" => [
        ("mu", @varname(mu)),
        ("tau", @varname(tau)),
        # TODO: Stan doesn't store theta_trans, but Turing doesn't store theta...
        # [("theta_trans[$i]", @varname(theta_trans[i])) for i in 1:8]...,
    ],
    "sblri-blr" => [
        [("beta[$i]", @varname(beta[i])) for i in 1:5]...,
        ("sigma", @varname(sigma)),
    ],
    "sblrc-blr" => [
        [("beta[$i]", @varname(beta[i])) for i in 1:5]...,
        ("sigma", @varname(sigma)),
    ],
)

# Include all model files at top level to avoid world age issues
for model_name in model_names
    include(joinpath(MODEL_DIR, model_name * ".jl"))
end

@testset "PosteriorDB model tests" begin
    for model_name in model_names
        post = PosteriorDB.posterior(PDB, model_name)
        ref_post = PosteriorDB.reference_posterior(post)
        if ref_post === nothing
            @info "Skipping $model_name (no reference posterior)"
            continue
        end
        if !haskey(PARAM_MAPS, model_name)
            @info "Skipping $model_name (no parameter mapping)"
            continue
        end

        @testset "$model_name" begin
            println("Testing: $model_name ...")

            data = PosteriorDB.load(PosteriorDB.dataset(post))
            turing_model = make_model(Val(Symbol(model_name)), data)

            ref_chain = FlexiChains.from_posteriordb_ref(ref_post)
            chn = sample(
                turing_model, NUTS(10_000, 0.65), MCMCThreads(), 1000, 10;
                thinning=10, chain_type=FlexiChains.VNChain,
            )

            for (ref_key, vn) in PARAM_MAPS[model_name]
                ref_samples = ref_chain[FlexiChains.Parameter(ref_key)]
                ref_mean = mean(ref_samples)
                ref_std = std(ref_samples)

                turing_samples = vec(chn[FlexiChains.Parameter(vn)])
                turing_mean = mean(turing_samples)

                threshold = 0.3 * max(ref_std, 1.0)
                diff = abs(turing_mean - ref_mean)
                @test diff < threshold
                if diff >= threshold
                    println("  ✗ $ref_key: turing=$(round(turing_mean; digits=3)) ref=$(round(ref_mean; digits=3)) diff=$(round(diff; digits=3)) threshold=$(round(threshold; digits=3))")
                end
            end
        end
    end
end
