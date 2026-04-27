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
arma-arma11        4     799.8 ns     2.4 μs       2.8 μs     2.2 μs     8.8 μs     7.6 μs
earnings-lh        3       1.7 μs     2.1 μs       3.6 μs     8.2 μs    28.2 μs    18.2 μs
es-esc            10     166.4 ns   767.1 ns     592.9 ns   570.5 ns   832.2 ns     1.0 μs
es-esn            10     168.6 ns   820.6 ns     670.5 ns   563.7 ns   962.4 ns     1.1 μs
garch-garch11      4       2.8 μs     3.1 μs       5.1 μs     5.4 μs     9.6 μs    11.6 μs
kidiq-km           3     923.7 ns     1.2 μs       2.0 μs     3.9 μs    12.3 μs     6.9 μs
rm-rhin           90       7.0 μs    13.4 μs     299.0 μs    14.5 μs    55.3 μs    52.7 μs
rd-rm             65       1.1 μs     2.6 μs      32.4 μs     2.5 μs     5.8 μs     7.1 μs
sblrc-blr          6     457.7 ns   878.7 ns       2.0 μs     1.3 μs     3.3 μs     1.9 μs
sblri-blr          6     528.0 ns   888.0 ns       2.6 μs     1.3 μs     3.3 μs     1.9 μs
==========================================================================================
```
