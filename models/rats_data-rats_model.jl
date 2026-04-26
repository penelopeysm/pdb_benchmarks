@model function rats_model(N, Npts, rat, x, y, xbar)
    mu_alpha ~ Normal(0, 100)
    mu_beta ~ Normal(0, 100)
    sigma_y ~ FlatPos(0.0)
    sigma_alpha ~ FlatPos(0.0)
    sigma_beta ~ FlatPos(0.0)
    alpha ~ filldist(Normal(mu_alpha, sigma_alpha), N)
    beta ~ filldist(Normal(mu_beta, sigma_beta), N)
    for n in 1:Npts
        irat = rat[n]
        mu = alpha[irat] + (beta[irat] * (x[n] - xbar))
        y[n] ~ Normal(mu, sigma_y)
    end
end

function make_model(::Val{Symbol("rats_data-rats_model")}, data)
    return rats_model(
        data["N"], data["Npts"], data["rat"],
        Float64.(data["x"]), Float64.(data["y"]), Float64(data["xbar"]),
    )
end
