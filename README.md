
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rinfa

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/rinfa)](https://CRAN.R-project.org/package=rinfa)
[![R-CMD-check](https://github.com/simonpcouch/rinfa/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/simonpcouch/rinfa/actions/workflows/R-CMD-check.yaml)
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
x <- matrix(rnorm(3e7), ncol = 3, dimnames = list(NULL, paste0("X", 1:3)))
y <- rnorm(1e7)

dat <- cbind(as.data.frame(x), y)

system.time(
  lm(y ~ ., dat)
)
#>    user  system elapsed 
#>   1.554   0.229   1.791

system.time(
  # lm()'s speedy friend, from base R
  .lm.fit(x, y)
)
#>    user  system elapsed 
#>   0.398   0.021   0.420

library(rinfa)

system.time({
  .linfa_linear_reg(x, y)
})
#>    user  system elapsed 
#>   0.208   0.083   0.297
```

To use rinfa with tidymodels, set the modeling engine to `"linfa"`:

``` r
# using the formula interface:
linfa_fit <- fit(linear_reg(engine = "linfa"), y ~ ., dat)

# using the (more performant, in this case) XY interface:
linfa_fit_xy <- fit_xy(linear_reg(engine = "linfa"), x = x, y = y)
```

## Available implementations

The rinfa package provides an additional engine `"linfa"` for the models
in the following table:

| model         | engine | mode           |
|:--------------|:-------|:---------------|
| decision_tree | linfa  | classification |
| linear_reg    | linfa  | regression     |
| logistic_reg  | linfa  | classification |
| multinom_reg  | linfa  | classification |
| naive_Bayes   | linfa  | classification |
| svm_linear    | linfa  | classification |

To read more about the design of rinfa, see [`R/README.md`](https://github.com/simonpcouch/rinfa/tree/main/R/README.md).
