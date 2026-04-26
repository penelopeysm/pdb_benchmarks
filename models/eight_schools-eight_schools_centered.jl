@model function eight_schools_centered(J, y, sigma)
    mu ~ Normal(0, 5)
    tau ~ truncated(Cauchy(0, 5); lower=0)
    theta ~ filldist(Normal(mu, tau), J)
    for i in 1:J
        y[i] ~ Normal(theta[i], sigma[i])
    end
end

function make_model(::Val{Symbol("eight_schools-eight_schools_centered")}, data)
    J = data["J"]
    y = Float64.(data["y"])
    sigma = Float64.(data["sigma"])
    return eight_schools_centered(J, y, sigma)
end
