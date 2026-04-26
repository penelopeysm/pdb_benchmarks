@model function radon_mn_radon_hierarchical_intercept_noncentered(
    J, N, county_idx, log_uppm, floor_measure, log_radon
)
    sigma_alpha ~ truncated(Normal(); lower=0)
    sigma_y ~ truncated(Normal(); lower=0)
    mu_alpha ~ Normal(0, 10)
    beta ~ filldist(Normal(0, 10), 2)
    alpha_raw ~ filldist(Normal(0, 1), J)
    alpha = mu_alpha .+ sigma_alpha .* alpha_raw

    # Note: These intermediate vectors are not necessary but we keep them to maintain parity
    # with the Stan implementation which does have them (otherwise the comparison feels a
    # bit unfair). In an optimised implementation we would just calculate mu[n] directly
    # inside the loop, which cuts around 25% of the time for AD.
    mu = Vector{typeof(mu_alpha)}(undef, N)
    muj = Vector{typeof(mu_alpha)}(undef, N)
    for n in 1:N
        muj[n] = alpha[county_idx[n]] + (log_uppm[n] * beta[1])
        mu[n] = muj[n] + (floor_measure[n] * beta[2])
        log_radon[n] ~ Normal(mu[n], sigma_y)

        # Optimised implementation:
        #
        # mu = alpha[county_idx[n]] + (log_uppm[n] * beta[1]) + (floor_measure[n] * beta[2])
        # log_radon[n] ~ Normal(mu, sigma_y)
    end
end

function make_model(::Val{Symbol("radon_mn-radon_hierarchical_intercept_noncentered")}, data)
    return radon_mn_radon_hierarchical_intercept_noncentered(
        data["J"],
        data["N"],
        Int.(data["county_idx"]),
        Float64.(data["log_uppm"]),
        Float64.(data["floor_measure"]),
        Float64.(data["log_radon"])
    )
end
