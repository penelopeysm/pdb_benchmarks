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

function test_model(
    ::Val{Symbol("gp_pois_regr-gp_pois_regr")},
    chn::FlexiChain{<:VarName},
    ref::FlexiChain{String},
)
    pdb = PosteriorDB.database()
    data = PosteriorDB.load(PosteriorDB.dataset(PosteriorDB.posterior(pdb, "gp_pois_regr-gp_pois_regr")))
    x = Float64.(data["x"])
    N = length(x)

    for (vn, ref_key) in [(@varname(rho), "rho"), (@varname(alpha), "alpha")]
        turing_mean = mean(vec(chn[vn]))
        ref_samples = ref[ref_key]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(turing_mean - ref_mean) < 0.3 * max(ref_std, 1.0)
    end

    # f = L_cov * f_tilde — reconstruct from chain samples
    rho_samples = vec(chn[@varname(rho)])
    alpha_samples = vec(chn[@varname(alpha)])
    S = length(rho_samples)
    f_means = zeros(N)
    for s in 1:S
        ρ, α = rho_samples[s], alpha_samples[s]
        K = Symmetric([α^2 * exp(-0.5 * ((x[a] - x[b]) / ρ)^2) for a in 1:N, b in 1:N] + 1e-10 * I)
        L = cholesky(K).L
        ft = [vec(chn[@varname(f_tilde[i])])[s] for i in 1:N]
        f_means .+= L * ft
    end
    f_means ./= S
    for i in 1:N
        ref_samples = ref["f[$i]"]
        ref_mean = mean(ref_samples)
        ref_std = std(ref_samples)
        @test abs(f_means[i] - ref_mean) < 0.3 * max(ref_std, 1.0)
    end
end
