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
#' @export
linfa_logistic_reg <- function(x, y) {
  check_x(x, y)
  check_y(y, "classification")

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
