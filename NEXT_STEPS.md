# Next models to add

All 147 PosteriorDB posteriors have Stan models and reference draws.
Current suite covers: hierarchical normals (eight_schools), hierarchical linear regression (rats), Bayesian linear regression (sblrc/sblri).

## Easy wins (simple, different model families)

| Posterior | Type | Params | Data | Notes |
|---|---|---|---|---|
| `arma-arma11` | ARMA(1,1) time series | 4 | T=200 | Sequential dependency, Normal+Cauchy priors |
| `earnings-logearn_height` | Simple regression | 3 | N=1192 | Log-transformed response, larger dataset |
| `dugongs_data-dugongs_model` | Non-linear growth curve | 4 | N=27 | `pow(lambda, x)` nonlinearity, Gamma prior, bounded param |
| `garch-garch11` | GARCH(1,1) volatility | 4 | T=200 | Sequential variance, coupled constraints (`alpha1 + beta1 < 1`) |
| `GLM_Binomial_data-GLM_Binomial_model` | Binomial GLM | 3 | N=40 | `binomial_logit` likelihood, first discrete-data GLM |
| `GLM_Poisson_Data-GLM_Poisson_model` | Poisson GLM | 4 | N=40 | `poisson_log` likelihood, uniform priors on bounded params |

## Medium complexity (hierarchical / random effects)

| Posterior | Type | Params | Data | Notes |
|---|---|---|---|---|
| `seeds_data-seeds_stanified_model` | Logistic random effects | 26 | I=21 | Binomial logit + random effects, bridges GLM and hierarchical |
| `surgical_data-surgical_model` | Hierarchical binomial | 14 | N=12 | InverseGamma prior, logistic link |
| `radon_mn-radon_hierarchical_intercept_noncentered` | Large hierarchical regression | 90 | N=919, J=85 | Classic benchmark, non-centered, county-level indexing |

## Harder but interesting

| Posterior | Type | Params | Data | Notes |
|---|---|---|---|---|
| `irt_2pl-irt_2pl` | Item Response Theory | 144 | 20x100 matrix | Lognormal prior, `bernoulli_logit` over matrix, largest param count |
| `low_dim_gauss_mix-low_dim_gauss_mix` | Gaussian mixture | 5 | N=1000 | `logsumexp` / `log_mix`, multimodal posterior |

## Suggested starting order

1. `arma-arma11` — time series coverage
2. `GLM_Binomial_data-GLM_Binomial_model` — discrete GLM coverage
3. `radon_mn-radon_hierarchical_intercept_noncentered` — large-scale hierarchical

## Full PosteriorDB checklist (147 models)

- [ ] `GLMM_Poisson_data-GLMM_Poisson_model`
- [ ] `GLMM_data-GLMM1_model`
- [ ] `GLM_Binomial_data-GLM_Binomial_model`
- [ ] `GLM_Poisson_Data-GLM_Poisson_model`
- [ ] `M0_data-M0_model`
- [ ] `Mb_data-Mb_model`
- [ ] `Mh_data-Mh_model`
- [ ] `Mt_data-Mt_model`
- [ ] `Mtbh_data-Mtbh_model`
- [ ] `Mth_data-Mth_model`
- [ ] `Rate_1_data-Rate_1_model`
- [ ] `Rate_2_data-Rate_2_model`
- [ ] `Rate_3_data-Rate_3_model`
- [ ] `Rate_4_data-Rate_4_model`
- [ ] `Rate_5_data-Rate_5_model`
- [ ] `Survey_data-Survey_model`
- [ ] `arK-arK`
- [ ] `arma-arma11`
- [ ] `bball_drive_event_0-hmm_drive_0`
- [ ] `bball_drive_event_1-hmm_drive_1`
- [ ] `bones_data-bones_model`
- [ ] `butterfly-multi_occupancy`
- [ ] `diamonds-diamonds`
- [ ] `dogs-dogs`
- [ ] `dogs-dogs_hierarchical`
- [ ] `dogs-dogs_log`
- [ ] `dogs-dogs_nonhierarchical`
- [ ] `dugongs_data-dugongs_model`
- [ ] `earnings-earn_height`
- [ ] `earnings-log10earn_height`
- [ ] `earnings-logearn_height`
- [ ] `earnings-logearn_height_male`
- [ ] `earnings-logearn_interaction`
- [ ] `earnings-logearn_interaction_z`
- [ ] `earnings-logearn_logheight_male`
- [ ] `ecdc0401-covid19imperial_v2`
- [ ] `ecdc0401-covid19imperial_v3`
- [ ] `ecdc0501-covid19imperial_v2`
- [ ] `ecdc0501-covid19imperial_v3`
- [x] `eight_schools-eight_schools_centered`
- [x] `eight_schools-eight_schools_noncentered`
- [ ] `election88-election88_full`
- [ ] `fims_Aus_Jpn_irt-2pl_latent_reg_irt`
- [ ] `garch-garch11`
- [ ] `gp_pois_regr-gp_pois_regr`
- [ ] `gp_pois_regr-gp_regr`
- [ ] `hmm_example-hmm_example`
- [ ] `hmm_gaussian_simulated-hmm_gaussian`
- [ ] `hudson_lynx_hare-lotka_volterra`
- [ ] `iohmm_reg_simulated-iohmm_reg`
- [ ] `irt_2pl-irt_2pl`
- [ ] `kidiq-kidscore_interaction`
- [ ] `kidiq-kidscore_momhs`
- [ ] `kidiq-kidscore_momhsiq`
- [ ] `kidiq-kidscore_momiq`
- [ ] `kidiq_with_mom_work-kidscore_interaction_c`
- [ ] `kidiq_with_mom_work-kidscore_interaction_c2`
- [ ] `kidiq_with_mom_work-kidscore_interaction_z`
- [ ] `kidiq_with_mom_work-kidscore_mom_work`
- [ ] `kilpisjarvi_mod-kilpisjarvi`
- [ ] `loss_curves-losscurve_sislob`
- [ ] `low_dim_gauss_mix-low_dim_gauss_mix`
- [ ] `low_dim_gauss_mix_collapse-low_dim_gauss_mix_collapse`
- [ ] `lsat_data-lsat_model`
- [ ] `mcycle_gp-accel_gp`
- [ ] `mcycle_splines-accel_splines`
- [ ] `mesquite-logmesquite`
- [ ] `mesquite-logmesquite_logva`
- [ ] `mesquite-logmesquite_logvas`
- [ ] `mesquite-logmesquite_logvash`
- [ ] `mesquite-logmesquite_logvolume`
- [ ] `mesquite-mesquite`
- [ ] `mnist-nn_rbm1bJ100`
- [ ] `mnist_100-nn_rbm1bJ10`
- [ ] `nes1972-nes`
- [ ] `nes1976-nes`
- [ ] `nes1980-nes`
- [ ] `nes1984-nes`
- [ ] `nes1988-nes`
- [ ] `nes1992-nes`
- [ ] `nes1996-nes`
- [ ] `nes2000-nes`
- [ ] `nes_logit_data-nes_logit_model`
- [ ] `normal_2-normal_mixture`
- [ ] `normal_5-normal_mixture_k`
- [ ] `one_comp_mm_elim_abs-one_comp_mm_elim_abs`
- [ ] `ovarian-logistic_regression_rhs`
- [ ] `pilots-pilots`
- [ ] `prideprejudice_chapter-ldaK5`
- [ ] `prideprejudice_paragraph-ldaK5`
- [ ] `prostate-logistic_regression_rhs`
- [ ] `radon_all-radon_county_intercept`
- [ ] `radon_all-radon_hierarchical_intercept_centered`
- [ ] `radon_all-radon_hierarchical_intercept_noncentered`
- [ ] `radon_all-radon_partially_pooled_centered`
- [ ] `radon_all-radon_partially_pooled_noncentered`
- [ ] `radon_all-radon_pooled`
- [ ] `radon_all-radon_variable_intercept_centered`
- [ ] `radon_all-radon_variable_intercept_noncentered`
- [ ] `radon_all-radon_variable_intercept_slope_centered`
- [ ] `radon_all-radon_variable_intercept_slope_noncentered`
- [ ] `radon_all-radon_variable_slope_centered`
- [ ] `radon_all-radon_variable_slope_noncentered`
- [ ] `radon_mn-radon_county_intercept`
- [ ] `radon_mn-radon_hierarchical_intercept_centered`
- [ ] `radon_mn-radon_hierarchical_intercept_noncentered`
- [ ] `radon_mn-radon_partially_pooled_centered`
- [ ] `radon_mn-radon_partially_pooled_noncentered`
- [ ] `radon_mn-radon_pooled`
- [ ] `radon_mn-radon_variable_intercept_centered`
- [ ] `radon_mn-radon_variable_intercept_noncentered`
- [ ] `radon_mn-radon_variable_intercept_slope_centered`
- [ ] `radon_mn-radon_variable_intercept_slope_noncentered`
- [ ] `radon_mn-radon_variable_slope_centered`
- [ ] `radon_mn-radon_variable_slope_noncentered`
- [ ] `radon_mod-radon_county`
- [x] `rats_data-rats_model`
- [ ] `rstan_downloads-prophet`
- [ ] `sat-hier_2pl`
- [x] `sblrc-blr`
- [x] `sblri-blr`
- [ ] `science_irt-grsm_latent_reg_irt`
- [ ] `seeds_data-seeds_centered_model`
- [ ] `seeds_data-seeds_model`
- [ ] `seeds_data-seeds_stanified_model`
- [ ] `sesame_data-sesame_one_pred_a`
- [ ] `sir-sir`
- [ ] `soil_carbon-soil_incubation`
- [ ] `state_wide_presidential_votes-hierarchical_gp`
- [ ] `surgical_data-surgical_model`
- [ ] `synthetic_grid_RBF_kernels-kronecker_gp`
- [ ] `three_docs1200-ldaK2`
- [ ] `three_men1-ldaK2`
- [ ] `three_men2-ldaK2`
- [ ] `three_men3-ldaK2`
- [ ] `timssAusTwn_irt-gpcm_latent_reg_irt`
- [ ] `traffic_accident_nyc-bym2_offset_only`
- [ ] `uk_drivers-state_space_stochastic_level_stochastic_seasonal`
- [ ] `wells_data-wells_daae_c_model`
- [ ] `wells_data-wells_dae_c_model`
- [ ] `wells_data-wells_dae_inter_model`
- [ ] `wells_data-wells_dae_model`
- [ ] `wells_data-wells_dist`
- [ ] `wells_data-wells_dist100_model`
- [ ] `wells_data-wells_dist100ars_model`
- [ ] `wells_data-wells_interaction_c_model`
- [ ] `wells_data-wells_interaction_model`
