using LinearAlgebra: cholesky, Symmetric, issuccess

@model function gp_pois_regr(x, k, N)
    rho ~ Gamma(25, 1 / 4)
    alpha ~ truncated(Normal(0, 2); lower=0)
    f_tilde ~ filldist(Normal(0, 1), N)
    dist_sq = (x .- x') .^ 2
    cov = alpha^2 .* exp.(-0.5 .* dist_sq ./ rho^2) + (1e-10 * I)
    F = cholesky(Symmetric(cov), check=false)
    if !issuccess(F)
        Turing.@addlogprob! -Inf
        return
    end
    f = F.L * f_tilde
    for i in 1:N
        k[i] ~ LogPoisson(f[i])
    end
end


function make_model(::Val{Symbol("gp_pois_regr-gp_pois_regr")}, data)
    x = Float64.(data["x"])
    k = Int.(data["k"])
    N = Int(data["N"])
    return gp_pois_regr(x, k, N)
end
