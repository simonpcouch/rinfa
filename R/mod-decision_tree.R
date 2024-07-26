#' Decision trees with linfa
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
#' @inheritParams parsnip::decision_tree
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(1:4, size = 100, replace = TRUE)
#'
#' m <- linfa_decision_tree(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @export
linfa_decision_tree <- function(x, y, cost_complexity = 0.00001,
                                tree_depth = 7L, min_n = 4) {
  check_x(x, y)
  check_y(y, "classification")

  check_integer(tree_depth)

  fit <-
    fit_decision_tree(
      c(x),
      y,
      ncol(x),
      min_impurity_decrease = cost_complexity,
      max_depth = tree_depth,
      min_weight_split = min_n
    )

  structure(
    list(fit = fit, ptype = vctrs::vec_slice(x, 0)),
    class = c(class(fit), "linfa_fit")
  )
}

#' @export
predict.linfa_decision_tree <- function(object, newdata) {
  predict_decision_tree(object$fit, c(newdata), n_features = ncol(object$ptype))
}
