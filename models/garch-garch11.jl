@model function garch_garch11(T, y, sigma1)
    mu ~ Flat()
    alpha0 ~ FlatPos(0.0)
    alpha1 ~ Uniform(0, 1)
    beta1 ~ Uniform(0, 1 - alpha1 + eps())

    sigma = Vector{typeof(mu)}(undef, T)
    sigma[1] = sigma1 # converts automatically to Dual if needed
    for t in 2:T
        sigma[t] = sqrt(alpha0 + alpha1 * (y[t-1] - mu)^2 + beta1 * sigma[t-1]^2)
    end
    for t in 1:T
        y[t] ~ Normal(mu, sigma[t])
    end
end

function make_model(::Val{Symbol("garch-garch11")}, data)
    return garch_garch11(
        data["T"],
        Float64.(data["y"]),
        Float64(data["sigma1"]),
    )
end

function test_model(
    ::Val{Symbol("garch-garch11")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    for (vn, ref_key) in [
        (@varname(mu), "mu"),
        (@varname(alpha0), "alpha0"),
        (@varname(alpha1), "alpha1"),
        (@varname(beta1), "beta1"),
    ]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
