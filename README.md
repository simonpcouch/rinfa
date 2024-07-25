
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rinfa

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/rinfa)](https://CRAN.R-project.org/package=rinfa)
<!-- badges: end -->

The goal of rinfa is to provide Rust bindings for parsnip model
specifications.

## Installation

You can install the development version of rinfa from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("simonpcouch/rinfa")
```

## Example

``` r
library(rinfa)

mod <- fit_linear_reg_linfa(x = rnorm(200), y = rnorm(100), n_features = 2)
#> FittedLinearRegression { intercept: 0.11565707451398831, params: [-0.07188344102651079, -0.19543392753376385], shape=[2], strides=[1], layout=CFcf (0xf), const ndim=1 }

predict_linear_reg_linfa(mod, x = rnorm(20), n_features = 2)
#>  [1] -0.01300691  0.19532300  0.17567218  0.13852921 -0.04187162 -0.02093193
#>  [7]  0.56993723  0.02773395 -0.00719894  0.04849419
```
