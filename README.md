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
julia --project=. test.jl
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
es-esc            10     179.0 ns   864.0 ns   765.3 ns     607.6 ns   422.3 ns   826.4 ns     1.0 μs     1.0 μs
es-esn            10     158.6 ns   852.9 ns   789.4 ns     506.6 ns   547.8 ns     1.0 μs   988.9 ns     1.0 μs
rd-rm             65       1.2 μs     5.1 μs     2.6 μs      37.8 μs     2.5 μs     5.8 μs     7.1 μs     7.1 μs
sblrc-blr          6     404.9 ns     1.5 μs   857.9 ns       1.7 μs     1.4 μs     3.3 μs     1.9 μs     1.9 μs
sblri-blr          6     444.5 ns     1.6 μs   894.5 ns       2.0 μs     1.3 μs     3.3 μs     2.0 μs     2.0 μs
================================================================================================================
```
