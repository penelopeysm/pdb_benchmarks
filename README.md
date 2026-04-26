# PosteriorDB Benchmarks

Turing vs Stan logp + gradient benchmarks on PosteriorDB models.

> [!NOTE]
>
> The benchmarking code and pretty-printing is mostly done with Claude.
> 
> The implementation of the Stan models, as well as the data for the models, are directly taken from [posteriordb itself](https://github.com/stan-dev/posteriordb/) (via [PosteriorDB.jl](https://github.com/sethaxen/PosteriorDB.jl/)).
> Turing models are hand-written / optimised by me.

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
