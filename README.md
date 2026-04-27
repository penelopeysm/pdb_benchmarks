> [!WARNING
>
> The benchmarks on this branch are run with DynamicPPL v0.35 (corresponding to Turing v0.37).
> This is far from the latest version!
> Performance will be **noticeably** worse.

## Results on this branch

```
==========================================================================================
                               eval                             gradient
                      ----------------------  --------------------------------------------
Model            dim       Turing       Stan      FwdDiff     Enzyme   Mooncake       Stan
------------------------------------------------------------------------------------------
arma-arma11        4       4.1 μs     2.4 μs       7.3 μs    11.3 μs    18.6 μs     7.6 μs
earnings-lh        3       2.4 μs     2.1 μs       4.9 μs    11.8 μs    36.3 μs    18.2 μs
earnings-lhm       4       2.7 μs     2.2 μs       6.0 μs    10.9 μs    39.2 μs    29.9 μs
es-esc            10     986.1 ns   740.6 ns       1.8 μs     2.1 μs     5.3 μs     1.0 μs
es-esn            10     967.7 ns   817.1 ns       1.9 μs     2.1 μs     5.5 μs     1.1 μs
garch-garch11      4       7.2 μs     3.1 μs      10.2 μs    15.8 μs    23.4 μs    11.5 μs
gpr-gpr           13       2.7 μs     2.3 μs      21.5 μs     9.3 μs    23.4 μs     4.7 μs
kidiq-km           3       1.8 μs     1.2 μs       3.0 μs     5.9 μs    15.3 μs     6.9 μs
rm-rhin           90      12.9 μs    13.4 μs     328.5 μs    18.3 μs    83.5 μs    52.8 μs
rd-rm             65       5.1 μs     2.8 μs      75.2 μs    36.2 μs    26.8 μs     7.2 μs
sblrc-blr          6       1.1 μs   850.5 ns       3.4 μs     2.7 μs     7.1 μs     1.9 μs
sblri-blr          6       1.1 μs   859.1 ns       3.7 μs     2.7 μs     7.0 μs     1.9 μs
==========================================================================================
```
