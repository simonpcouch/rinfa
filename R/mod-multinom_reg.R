# interface for `fit_multinom_reg()`, implemented in the logistic.rs module
#' Multinomial regression with linfa
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
#' @export
linfa_multinom_reg <- function(x, y) {
  check_x(x, y)
  check_y(y, "classification")

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
