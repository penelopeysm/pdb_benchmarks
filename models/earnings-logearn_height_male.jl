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

function test_model(
    ::Val{Symbol("earnings-logearn_height_male")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    for (vn, ref_key) in [
        (@varname(beta[1]), "beta[1]"),
        (@varname(beta[2]), "beta[2]"),
        (@varname(beta[3]), "beta[3]"),
        (@varname(sigma), "sigma"),
    ]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
