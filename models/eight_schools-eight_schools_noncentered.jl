@model function eight_schools_noncentered(J, y, sigma)
    mu ~ Normal(0, 5)
    tau ~ truncated(Cauchy(0, 5); lower=0)
    theta_trans ~ filldist(Normal(), J)
    for i in 1:J
        y[i] ~ Normal(theta_trans[i] * tau + mu, sigma[i])
    end
end

function make_model(data)
    J = data["J"]
    y = Float64.(data["y"])
    sigma = Float64.(data["sigma"])
    return eight_schools_noncentered(J, y, sigma)
end
