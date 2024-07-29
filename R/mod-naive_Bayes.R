#' Naive bayes with linfa
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
#' @inheritParams parsnip::naive_Bayes
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(1:4, size = 100, replace = TRUE)
#'
#' m <- linfa_naive_Bayes(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @keywords internal
#' @export
linfa_naive_Bayes <- function(x, y, smoothness = 1e-9) {
  check_x(x, y)
  check_y(y, "classification")
  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    y <- as.integer(y)
  }

  fit <-
    fit_naive_Bayes(
      c(x),
      y,
      ncol(x),
      var_smoothing = smoothness
    )

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_naive_Bayes <- function(object, newdata) {
  predict_naive_Bayes(object$fit, c(newdata), n_features = ncol(object$ptype))
}


# nocov start

make_naive_Bayes_linfa <- function() {
  parsnip::set_model_engine(
    model = "naive_Bayes",
    mode = "classification",
    eng = "linfa"
  )

  parsnip::set_dependency(
    model = "naive_Bayes",
    eng = "linfa",
    pkg = "rinfa",
    mode = "classification"
  )

  parsnip::set_fit(
    model = "naive_Bayes",
    eng = "linfa",
    mode = "classification",
    value = list(
      interface = "matrix",
      protect = c("x", "y"),
      func = c(pkg = "rinfa", fun = "linfa_naive_Bayes"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "naive_Bayes",
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
    model = "naive_Bayes",
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

