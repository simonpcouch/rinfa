
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
x <- matrix(rnorm(3e6), ncol = 3)
y <- rnorm(1e6)

dat <- cbind(as.data.frame(x), y)

system.time(
  lm(y ~ ., dat)
)
#>    user  system elapsed 
#>   0.136   0.020   0.156

system.time(
  # lm()'s speedy friend
  lm.fit(x, y)
)
#>    user  system elapsed 
#>   0.038   0.002   0.040

library(rinfa)

x_rinfa <- c(x)

system.time({
  fit_linear_reg_linfa(x_rinfa, y, n_features = 3)
})
#>    user  system elapsed 
#>   0.012   0.003   0.016
```
