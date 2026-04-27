@model function earnings_logearn_height(log_earn, height, N)
    beta ~ filldist(Flat(), 2)
    sigma ~ FlatPos(0.0)
    log_earn ~ MvNormal(beta[1] .+ beta[2] .* height, sigma^2 * I)
end

function make_model(::Val{Symbol("earnings-logearn_height")}, data)
    return earnings_logearn_height(
        log.(Float64.(data["earn"])),
        Float64.(data["height"]),
        data["N"],
    )
end
