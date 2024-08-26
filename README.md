
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

# the usual formula interface
system.time(
  lm(y ~ ., dat)
)
#>    user  system elapsed 
#>   1.097   0.189   1.292

system.time(
  # lm()'s speedy friend (still from base R)
  .lm.fit(x, y)
)
#>    user  system elapsed 
#>   0.321   0.022   0.344

# rinfa's implementation
library(rinfa)

system.time({
  .linfa_linear_reg(x, y)
})
#>    user  system elapsed 
#>   0.115   0.046   0.161
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

To read more about the design of rinfa, see
[`R/README.md`](https://github.com/simonpcouch/rinfa/tree/main/R/README.md).
