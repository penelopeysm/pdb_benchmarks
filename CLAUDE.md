# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Benchmarks comparing Turing.jl vs Stan for log-probability evaluation and gradient computation on models from PosteriorDB. Stan models and data come from PosteriorDB; Turing models are hand-written.

## Commands

```bash
julia --project=. bench.jl                                        # all models
julia --project=. bench.jl eight_schools-eight_schools_centered   # one model
julia --project=. bench.jl --eval-only                            # skip gradients
```

## Architecture

**bench.jl** — Main benchmark driver. For each model: loads PosteriorDB data, runs Turing logp+gradient benchmarks (ForwardDiff, Enzyme, Mooncake), compiles and runs Stan via BridgeStan, prints comparison table.

**models/*.jl** — Each file is named `<posterior-name>.jl` (matching the PosteriorDB posterior name exactly) and contains:
1. A `@model function` defining the Turing model
2. A `make_model(::Val{Symbol("<posterior-name>")}, data)` method that unpacks the PosteriorDB data dict and returns the instantiated model

bench.jl discovers models by scanning the `models/` directory for `.jl` files and `include()`-ing them.

## Conventions for Model Files

- The filename must exactly match the PosteriorDB posterior name (with `.jl` extension)
- `make_model` uses `Val{Symbol(...)}` dispatch so multiple models coexist after inclusion
- Convert data values to `Float64` where PosteriorDB returns integers (e.g. `Float64.(data["y"])`)
- Use `PosteriorDB.database()` to get the PosteriorDB database (uses the Julia package's built-in path, not a local checkout)

## Adding a Model

1. Pick a posterior from PosteriorDB
2. Create `models/<posterior-name>.jl` with the `@model` function and `make_model` dispatcher
3. Run `julia --project=. bench.jl <posterior-name>` to verify it works
