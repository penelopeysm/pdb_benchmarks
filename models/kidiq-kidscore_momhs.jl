@model function kidiq_kidscore_momhs(kid_score, mom_hs, N)
    beta ~ filldist(Flat(), 2)
    sigma ~ truncated(Cauchy(0, 2.5); lower=0)
    kid_score ~ MvNormal(beta[1] .+ beta[2] .* mom_hs, sigma^2 * I)
end

function make_model(::Val{Symbol("kidiq-kidscore_momhs")}, data)
    return kidiq_kidscore_momhs(
        Float64.(data["kid_score"]),
        Bool.(data["mom_hs"]),
        data["N"],
    )
end

function test_model(
    ::Val{Symbol("kidiq-kidscore_momhs")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    for (vn, ref_key) in [
        (@varname(beta[1]), "beta[1]"),
        (@varname(beta[2]), "beta[2]"),
        (@varname(sigma), "sigma"),
    ]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
