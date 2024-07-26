
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
x <- matrix(rnorm(3e7), ncol = 3)
y <- rnorm(1e7)

dat <- cbind(as.data.frame(x), y)

system.time(
  lm(y ~ ., dat)
)
#>    user  system elapsed 
#>   1.042   0.261   1.359

system.time(
  # lm()'s speedy friend
  lm.fit(x, y)
)
#>    user  system elapsed 
#>   0.383   0.039   0.421

library(rinfa)

system.time({
  linfa_linear_reg(x, y)
})
#>    user  system elapsed 
#>   0.175   0.078   0.255
```
