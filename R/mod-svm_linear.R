# interface for `fit_svm_linear()`, implemented in the svm.rs module
#' Support vector machines with linfa
#'
#' @param x A numeric matrix of predictors.
#' @param y A logical vector of outcome values.
#' @inheritParams parsnip::svm_linear
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(c(0L, 1L), size = 100, replace = TRUE)
#'
#' m <- linfa_svm_linear(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @export
linfa_svm_linear <- function(x, y, cost = 1) {
  check_x(x, y)
  check_y(y, "classification")
  # TODO: check that y is encoded as 0/1 or is two-class and can be transformed to it

  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    # TODO: this is gross, but - 1 aligns levels(y) with y if y was coerced
    # from integer
    y <- as.integer(y) - 1L
  }

  fit <- fit_svm_linear(c(x), y, ncol(x), c = cost)

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_svm_linear <- function(object, newdata) {
  predict_svm_linear(object$fit, c(newdata), n_features = ncol(object$ptype))
}
