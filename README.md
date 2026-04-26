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
arma-arma11        4     802.1 ns     2.4 μs       2.5 μs     2.3 μs     8.8 μs     7.6 μs
earnings-lh        3       1.3 μs     2.1 μs       3.7 μs     8.7 μs    31.8 μs    18.2 μs
es-esc            10     172.1 ns   761.0 ns     645.8 ns   534.1 ns   838.1 ns     1.0 μs
es-esn            10     168.8 ns   811.3 ns     632.1 ns   549.4 ns     1.0 μs     1.1 μs
kidiq-km           3     843.8 ns     1.2 μs       1.8 μs     4.0 μs    11.7 μs     6.9 μs
rm-rhin           90       7.8 μs    13.6 μs     298.8 μs    14.1 μs    55.9 μs    53.8 μs
rd-rm             65       1.2 μs     2.6 μs      32.9 μs     2.5 μs     6.0 μs     7.1 μs
sblrc-blr          6     466.9 ns   857.9 ns       1.9 μs     1.3 μs     3.1 μs     1.9 μs
sblri-blr          6     451.3 ns   859.8 ns       1.9 μs     1.4 μs     3.3 μs     1.9 μs
==========================================================================================
```
