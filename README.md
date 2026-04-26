# PosteriorDB Benchmarks

Turing vs Stan logp + gradient benchmarks on PosteriorDB models.

> [!NOTE]
>
> The implementation of the Stan models, as well as the data for the models, are directly taken from [posteriordb itself](https://github.com/stan-dev/posteriordb/tree/master/posterior_database/models/stan) (via [PosteriorDB.jl](https://github.com/sethaxen/PosteriorDB.jl/)).
> Turing models are hand-written / optimised by me.
> The benchmarking code and pretty-printing is mostly written by Claude.

## Running

```bash
julia --project=. bench.jl                                         # all models
julia --project=. bench.jl eight_schools-eight_schools_centered    # one model
julia --project=. bench.jl --eval-only                             # skip gradients
```

## Adding a model

1. Pick a posterior from PosteriorDB (e.g. `eight_schools-eight_schools_noncentered`).
2. Create `models/<posterior-name>.jl` with:
   - A `@model` function defining the Turing model.
   - A `setup(data)` function that takes the PosteriorDB dataset dict and returns
     the instantiated Turing model.

The Stan code and dataset are pulled automatically from PosteriorDB.

## Are the models correctly implemented?

```bash
julia --project=. --threads=10 test.jl
```

will sample from the Turing model with NUTS and check the results against the PosteriorDB reference samples.

## Show me the results

(On my M1 MacBook Pro; YMMV.)

StanProp means Stan with `propto=true`.

```
================================================================================================================
                                    eval                                        gradient
                      ---------------------------------  -------------------------------------------------------
Model            dim       Turing   StanProp       Stan      FwdDiff     Enzyme   Mooncake   StanProp       Stan
----------------------------------------------------------------------------------------------------------------
arma-arma11        4     804.4 ns     4.8 μs     2.5 μs       2.7 μs     2.3 μs     8.8 μs     7.7 μs     7.7 μs
es-esc            10     160.6 ns   867.4 ns   745.8 ns     596.1 ns   544.7 ns   871.3 ns   991.7 ns     1.0 μs
es-esn            10     165.5 ns   905.0 ns   830.9 ns     639.5 ns   571.9 ns   979.2 ns     1.0 μs     1.1 μs
rd-rm             65       1.1 μs     5.2 μs     2.6 μs      32.6 μs     2.5 μs     5.8 μs     7.2 μs     7.2 μs
sblrc-blr          6     428.8 ns     1.5 μs   868.7 ns       1.8 μs     1.6 μs     3.0 μs     1.9 μs     1.9 μs
sblri-blr          6     438.1 ns     1.5 μs   864.0 ns       1.9 μs     1.4 μs     3.0 μs     1.9 μs     1.9 μs
================================================================================================================
```
