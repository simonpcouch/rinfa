# interface for `fit_logistic_reg()`, implemented in the logistic.rs module
#' Logistic regression with linfa
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
# @inheritParams parsnip::logistic_reg
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(1:2, size = 100, replace = TRUE)
#'
#' m <- linfa_logistic_reg(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @keywords internal
#' @export
linfa_logistic_reg <- function(x, y) {
  check_x(x, y)
  check_y(y, "classification")
  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    # TODO: this is gross, but - 1 aligns levels(y) with y if y was coerced
    # from integer
    y <- as.integer(y) - 1L
  }

  # TODO: check that there are not more than two classes
  fit <- fit_logistic_reg(c(x), y, ncol(x))

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_logistic_reg <- function(object, newdata) {
  predict_logistic_reg(object$fit, c(newdata), n_features = ncol(object$ptype))
}

# nocov start

make_logistic_reg_linfa <- function() {
  parsnip::set_model_engine(
    model = "logistic_reg",
    mode = "classification",
    eng = "linfa"
  )

  parsnip::set_dependency(
    model = "logistic_reg",
    eng = "linfa",
    pkg = "rinfa",
    mode = "classification"
  )

  parsnip::set_fit(
    model = "logistic_reg",
    eng = "linfa",
    mode = "classification",
    value = list(
      interface = "matrix",
      protect = c("x", "y"),
      func = c(pkg = "rinfa", fun = "linfa_logistic_reg"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "logistic_reg",
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
    model = "logistic_reg",
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

