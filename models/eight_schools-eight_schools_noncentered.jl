@model function eight_schools_noncentered(J, y, sigma)
    mu ~ Normal(0, 5)
    tau ~ truncated(Cauchy(0, 5); lower=0)
    theta_trans ~ filldist(Normal(), J)
    for i in 1:J
        y[i] ~ Normal(theta_trans[i] * tau + mu, sigma[i])
    end
end

function make_model(::Val{Symbol("eight_schools-eight_schools_noncentered")}, data)
    J = data["J"]
    y = Float64.(data["y"])
    sigma = Float64.(data["sigma"])
    return eight_schools_noncentered(J, y, sigma)
end

function test_model(
    ::Val{Symbol("eight_schools-eight_schools_noncentered")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    for (vn, ref_key) in [(@varname(mu), "mu"), (@varname(tau), "tau")]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
    # theta = theta_trans * tau + mu
    mu_samples = chn[@varname(mu)]
    tau_samples = chn[@varname(tau)]
    for i in 1:8
        theta_samples = chn[@varname(theta_trans[i])] .* tau_samples .+ mu_samples
        ref_samples = ref["theta[$i]"]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(mean(theta_samples) - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
