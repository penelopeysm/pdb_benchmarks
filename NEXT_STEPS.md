# Next models to add

Only 47 of 147 PosteriorDB posteriors have reference draws. Focus on these so we can actually test correctness via `test_model`.

## Current suite

| Model | Has ref posterior | Has `test_model` |
|---|---|---|
| `arma-arma11` | yes | yes |
| `earnings-logearn_height` | yes | yes |
| `earnings-logearn_height_male` | yes | yes |
| `eight_schools-eight_schools_centered` | yes | yes |
| `eight_schools-eight_schools_noncentered` | yes | yes |
| `garch-garch11` | yes | yes |
| `gp_pois_regr-gp_pois_regr` | yes | yes |
| `kidiq-kidscore_momhs` | yes | yes |
| `sblrc-blr` | yes | yes |
| `sblri-blr` | yes | yes |
| `radon_mn-radon_hierarchical_intercept_noncentered` | **no** | no |
| `rats_data-rats_model` | **no** | no |

Coverage: hierarchical normals, Bayesian linear regression, ARMA time series, GARCH volatility, GP with latent Poisson. The radon and rats models are benchmarkable but not testable.

## Easy wins (simple regressions with reference draws)

These are all Normal-likelihood regressions with `beta[1..K]` + `sigma` params — straightforward to implement and test.

| Posterior | Params | Data | Notes |
|---|---|---|---|
| `kilpisjarvi_mod-kilpisjarvi` | 3 (`alpha`, `beta`, `sigma`) | N=? | Linear regression with informative priors |
| `mesquite-logmesquite_logvolume` | 3 (`beta[1:2]`, `sigma`) | N=? | Simplest mesquite variant |
| `gp_pois_regr-gp_regr` | 3 (`rho`, `alpha`, `sigma`) | N=? | GP regression (no latent f) |

Bonus: each family has multiple variants sharing the same dataset, so once one is done the rest are quick:
- **earnings**: 7 variants (3–5 params each)
- **kidiq / kidiq_with_mom_work**: 8 variants (3–5 params each)
- **mesquite**: 6 variants (3–8 params each)
- **nes**: 8 variants (all 10 params, same model, different election years)

## Medium complexity

| Posterior | Params | Data | Notes |
|---|---|---|---|
| `one_comp_mm_elim_abs-one_comp_mm_elim_abs` | 4 (`k_a`, `K_m`, `V_m`, `sigma`) | Pharmacokinetics | ODE-based, Michaelis-Menten elimination |
| `diamonds-diamonds` | 26 (`b[1:24]`, `Intercept`, `sigma`) | N=? | brms-style regression, many predictors |
| `arK-arK` | 7 (`alpha`, `beta[1:5]`, `sigma`) | T=200 | Higher-order AR, generalises `arma-arma11` |

## Harder but interesting

| Posterior | Params | Data | Notes |
|---|---|---|---|
| `hmm_example-hmm_example` | 6 (`theta1[1:2]`, `theta2[1:2]`, `mu[1:2]`) | N=? | HMM — needs marginalisation or forward algorithm |
| `bball_drive_event_0-hmm_drive_0` | 8 | N=? | HMM with Poisson emissions |
| `hudson_lynx_hare-lotka_volterra` | 8 (`theta[1:4]`, `z_init[1:2]`, `sigma[1:2]`) | N=21 | ODE predator-prey, requires DiffEq integration |
| `low_dim_gauss_mix-low_dim_gauss_mix` | 5 (`mu[1:2]`, `sigma[1:2]`, `theta`) | N=1000 | Gaussian mixture, multimodal posterior |
| `mcycle_gp-accel_gp` | 66 | N=? | brms GP model, heteroscedastic, large latent space |

## Suggested priority

1. Batch out variant families (remaining earnings, kidiq, mesquite, nes)
2. `gp_pois_regr-gp_regr` — GP without latent variables, shares data with `gp_pois_regr`
3. `kilpisjarvi_mod-kilpisjarvi` — simple regression with informative priors
4. `hmm_example-hmm_example` — if HMM support in Turing is viable
5. `hudson_lynx_hare-lotka_volterra` — ODE coverage

## All 47 posteriors with reference draws

- [x] `arma-arma11`
- [ ] `arK-arK`
- [ ] `bball_drive_event_0-hmm_drive_0`
- [ ] `bball_drive_event_1-hmm_drive_1`
- [ ] `diamonds-diamonds`
- [ ] `earnings-earn_height`
- [ ] `earnings-log10earn_height`
- [x] `earnings-logearn_height`
- [x] `earnings-logearn_height_male`
- [ ] `earnings-logearn_interaction`
- [ ] `earnings-logearn_interaction_z`
- [ ] `earnings-logearn_logheight_male`
- [x] `eight_schools-eight_schools_centered`
- [x] `eight_schools-eight_schools_noncentered`
- [x] `garch-garch11`
- [x] `gp_pois_regr-gp_pois_regr`
- [ ] `gp_pois_regr-gp_regr`
- [ ] `hmm_example-hmm_example`
- [ ] `hudson_lynx_hare-lotka_volterra`
- [ ] `kidiq-kidscore_interaction`
- [x] `kidiq-kidscore_momhs`
- [ ] `kidiq-kidscore_momhsiq`
- [ ] `kidiq-kidscore_momiq`
- [ ] `kidiq_with_mom_work-kidscore_interaction_c`
- [ ] `kidiq_with_mom_work-kidscore_interaction_c2`
- [ ] `kidiq_with_mom_work-kidscore_interaction_z`
- [ ] `kidiq_with_mom_work-kidscore_mom_work`
- [ ] `kilpisjarvi_mod-kilpisjarvi`
- [ ] `low_dim_gauss_mix-low_dim_gauss_mix`
- [ ] `mcycle_gp-accel_gp`
- [ ] `mesquite-logmesquite`
- [ ] `mesquite-logmesquite_logva`
- [ ] `mesquite-logmesquite_logvas`
- [ ] `mesquite-logmesquite_logvash`
- [ ] `mesquite-logmesquite_logvolume`
- [ ] `mesquite-mesquite`
- [ ] `nes1972-nes`
- [ ] `nes1976-nes`
- [ ] `nes1980-nes`
- [ ] `nes1984-nes`
- [ ] `nes1988-nes`
- [ ] `nes1992-nes`
- [ ] `nes1996-nes`
- [ ] `nes2000-nes`
- [ ] `one_comp_mm_elim_abs-one_comp_mm_elim_abs`
- [x] `sblrc-blr`
- [x] `sblri-blr`
