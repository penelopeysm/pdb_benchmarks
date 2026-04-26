@model function sblri_blr(X, y, D)
    beta ~ filldist(Normal(0, 10), D)
    sigma ~ truncated(Normal(0, 10); lower=0)
    y ~ MvNormal(X * beta, sigma^2 * I)
end

function make_model(::Val{Symbol("sblri-blr")}, data)
    return sblri_blr(data["X"], data["y"], data["D"])
end
