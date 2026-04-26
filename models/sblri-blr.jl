@model function sblri_blr(X, y, D)
    beta ~ filldist(Normal(0, 10), D)
    sigma ~ truncated(Normal(0, 10); lower=0)
    y ~ MvNormal(X * beta, sigma^2 * I)
end

function make_model(::Val{Symbol("sblri-blr")}, data)
    return sblri_blr(data["X"], data["y"], data["D"])
end

function test_model(
    ::Val{Symbol("sblri-blr")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    for (vn, ref_key) in [
        [(@varname(beta[i]), "beta[$i]") for i in 1:5]...,
        (@varname(sigma), "sigma"),
    ]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
