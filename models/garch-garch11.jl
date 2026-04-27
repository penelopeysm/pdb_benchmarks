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
