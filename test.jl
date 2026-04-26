#!/usr/bin/env julia
#
# Test Turing model implementations against PosteriorDB reference posteriors.
#
# Usage:
#   julia --project=. test.jl                                           # all models
#   julia --project=. test.jl eight_schools-eight_schools_noncentered   # single model

using Test, Statistics, Random
using Turing, DynamicPPL
using FlexiChains: FlexiChains, FlexiChain
using Random: Xoshiro
using PosteriorDB

get(ENV, "CI", "false") == "true" && Turing.setprogress!(false)

POSTERIORDB_PATH = joinpath(dirname(@__DIR__), "posteriordb", "posterior_database")
PDB = isdir(POSTERIORDB_PATH) ? PosteriorDB.database(POSTERIORDB_PATH) : PosteriorDB.database()
MODEL_DIR = joinpath(@__DIR__, "models")

args = filter(a -> !startswith(a, "--"), ARGS)
if isempty(args)
    model_names = sort!([replace(f, ".jl" => "") for f in readdir(MODEL_DIR) if endswith(f, ".jl")])
else
    model_names = args
end

test_model(::Val{sym}, chn, ref) where {sym} = @info "No test implemented for $sym"

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

        @testset "$model_name" begin
            println("Testing: $model_name ...")

            data = PosteriorDB.load(PosteriorDB.dataset(post))
            turing_model = make_model(Val(Symbol(model_name)), data)

            ref_chain = FlexiChains.from_posteriordb_ref(ref_post)
            chn = sample(
                Xoshiro(468), turing_model, NUTS(10_000, 0.65), MCMCThreads(), 1000, 10;
                thinning=10, chain_type=FlexiChains.VNChain,
            )

            test_model(Val(Symbol(model_name)), chn, ref_chain)
        end
    end
end
