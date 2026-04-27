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

Note that all Stan benchmarks are run with `propto=false` (using `propto=true` makes no difference for the gradients but makes the primals come out slower in benchmarks).

```
==========================================================================================
                               eval                             gradient
                      ----------------------  --------------------------------------------
Model            dim       Turing       Stan      FwdDiff     Enzyme   Mooncake       Stan
------------------------------------------------------------------------------------------
arma-arma11        4     807.1 ns     2.5 μs       2.9 μs     2.2 μs     8.8 μs     7.6 μs
earnings-lh        3       1.5 μs     2.1 μs       3.7 μs     8.7 μs    27.9 μs    18.2 μs
earnings-lhm       4       2.0 μs     2.4 μs       4.9 μs     7.5 μs    35.0 μs    29.8 μs
es-esc            10     167.4 ns   760.7 ns     562.1 ns   516.8 ns   827.6 ns     1.1 μs
es-esn            10     168.6 ns   814.8 ns     673.3 ns   558.2 ns   970.4 ns     1.1 μs
garch-garch11      4       2.7 μs     3.1 μs       5.0 μs     5.4 μs     9.4 μs    11.5 μs
kidiq-km           3       1.4 μs     1.2 μs       2.1 μs     3.9 μs    11.5 μs     6.9 μs
rm-rhin           90       8.1 μs    13.2 μs     299.4 μs    15.9 μs    55.5 μs    53.0 μs
rd-rm             65       1.1 μs     2.6 μs      31.9 μs     2.5 μs     5.8 μs     7.1 μs
sblrc-blr          6     447.4 ns   881.1 ns       1.9 μs     1.3 μs     3.4 μs     1.9 μs
sblri-blr          6     529.7 ns   895.8 ns       2.6 μs     1.3 μs     3.0 μs     1.9 μs
==========================================================================================
```
