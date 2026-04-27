@model function earnings_logearn_height_male(log_earn, height, male, N)
    beta ~ filldist(Flat(), 3)
    sigma ~ FlatPos(0.0)
    log_earn ~ MvNormal(beta[1] .+ beta[2] .* height .+ beta[3] .* male, sigma^2 * I)
end

function make_model(::Val{Symbol("earnings-logearn_height_male")}, data)
    return earnings_logearn_height_male(
        log.(Float64.(data["earn"])),
        Float64.(data["height"]),
        Bool.(data["male"]),
        data["N"],
    )
end
