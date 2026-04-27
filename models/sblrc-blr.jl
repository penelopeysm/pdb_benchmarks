@model function sblrc_blr(X, y, D)
    beta ~ filldist(Normal(0, 10), D)
    sigma ~ truncated(Normal(0, 10); lower=0)
    y ~ MvNormal(X * beta, sigma^2 * I)
end

function make_model(::Val{Symbol("sblrc-blr")}, data)
    return sblrc_blr(data["X"], data["y"], data["D"])
end
