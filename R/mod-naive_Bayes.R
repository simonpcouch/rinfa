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
#' @export
linfa_naive_Bayes <- function(x, y, smoothness = 1e-9) {
  check_x(x, y)
  check_y(y, "classification")
  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    # TODO: this is gross, but - 1 aligns levels(y) with y if y was coerced
    # from integer
    y <- as.integer(y) - 1L
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
