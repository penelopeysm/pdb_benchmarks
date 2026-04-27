@model function kidiq_kidscore_momhs(kid_score, mom_hs, N)
    beta ~ filldist(Flat(), 2)
    sigma ~ truncated(Cauchy(0, 2.5); lower=0)
    kid_score ~ MvNormal(beta[1] .+ beta[2] .* mom_hs, sigma^2 * I)
end

function make_model(::Val{Symbol("kidiq-kidscore_momhs")}, data)
    return kidiq_kidscore_momhs(
        Float64.(data["kid_score"]),
        Bool.(data["mom_hs"]),
        data["N"],
    )
end
