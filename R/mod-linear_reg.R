#' Linear regression with linfa
#'
#' @description
#' This is an internal function that interfaces directly with the Rust
#' implementation from linfa. The preferred entry point is via tidymodels,
#' i.e. with:
#'
#' ```
#' model_spec <- linear_reg(engine = "linfa")
#' model <- fit(model_spec, mpg ~ ., mtcars)
#' ```
#' @param x A numeric matrix of predictors.
#' @param y A numeric vector of outcome values.
# @inheritParams parsnip::linear_reg
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- rnorm(100)
#'
#' m <- linfa_linear_reg(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @keywords internal
#' @export
.linfa_linear_reg <- function(x, y) {
  check_x(x, y)
  check_y(y, "regression")

  fit <- fit_linear_reg(c(x), y, ncol(x))

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_linear_reg <- function(object, newdata) {
  predict_linear_reg(object$fit, c(newdata), n_features = ncol(object$ptype))
}

# nocov start

make_linear_reg_linfa <- function() {
  parsnip::set_model_engine(
    model = "linear_reg",
    mode = "regression",
    eng = "linfa"
  )

  parsnip::set_dependency(
    model = "linear_reg",
    eng = "linfa",
    pkg = "rinfa",
    mode = "regression"
  )

  parsnip::set_fit(
    model = "linear_reg",
    eng = "linfa",
    mode = "regression",
    value = list(
      interface = "matrix",
      protect = c("x", "y"),
      func = c(pkg = "rinfa", fun = ".linfa_linear_reg"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "linear_reg",
    mode = "regression",
    eng = "linfa",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "linear_reg",
    eng = "linfa",
    mode = "regression",
    type = "numeric",
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
