# interface for `fit_multinom_reg()`, implemented in the logistic.rs module
#' Multinomial regression with linfa
#'
#' @description
#' This is an internal function that interfaces directly with the Rust
#' implementation from linfa. The preferred entry point is via tidymodels,
#' i.e. with:
#'
#' ```
#' model_spec <- multinom_reg(engine = "linfa", mode = "classification")
#' model <- fit(model_spec, as.factor(cyl) ~ ., mtcars)
#' ```
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
# @inheritParams parsnip::multinom_reg
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(1:4, size = 100, replace = TRUE)
#'
#' m <- linfa_multinom_reg(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @keywords internal
#' @export
.linfa_multinom_reg <- function(x, y) {
  check_x(x, y)
  check_y(y, "classification")
  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    y <- as.integer(y)
  }

  # TODO: check that there are at least two classes
  fit <- fit_multinom_reg(c(x), y, ncol(x))

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_multinom_reg <- function(object, newdata) {
  predict_multinom_reg(object$fit, c(newdata), n_features = ncol(object$ptype))
}


# nocov start

make_multinom_reg_linfa <- function() {
  parsnip::set_model_engine(
    model = "multinom_reg",
    mode = "classification",
    eng = "linfa"
  )

  parsnip::set_dependency(
    model = "multinom_reg",
    eng = "linfa",
    pkg = "rinfa",
    mode = "classification"
  )

  parsnip::set_fit(
    model = "multinom_reg",
    eng = "linfa",
    mode = "classification",
    value = list(
      interface = "matrix",
      protect = c("x", "y"),
      func = c(pkg = "rinfa", fun = ".linfa_multinom_reg"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "multinom_reg",
    mode = "classification",
    eng = "linfa",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "multinom_reg",
    eng = "linfa",
    mode = "classification",
    type = "class",
    value = list(
      pre = NULL,
      post = NULL,
      func = c(fun = "predict"),
      args = list(
        object = quote(object$fit),
        newdata = quote(new_data)
      )
    )
  )
}

# nocov end

