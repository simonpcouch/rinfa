#' Decision trees with linfa
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
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
#' @export
linfa_linear_reg <- function(x, y) {
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
