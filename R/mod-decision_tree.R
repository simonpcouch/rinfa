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
  # TODO: this is probably not the way... parsnip requires that the outcome
  # is a factor, but linfa takes outcomes as integers
  if (inherits(y, "factor")) {
    y <- as.integer(y)
  }

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


# nocov start

make_decision_tree_linfa <- function() {
  parsnip::set_model_engine(
    model = "decision_tree",
    mode = "classification",
    eng = "linfa"
  )

  parsnip::set_dependency(
    model = "decision_tree",
    eng = "linfa",
    pkg = "rinfa",
    mode = "classification"
  )

  parsnip::set_fit(
    model = "decision_tree",
    eng = "linfa",
    mode = "classification",
    value = list(
      interface = "matrix",
      protect = c("x", "y"),
      func = c(pkg = "rinfa", fun = "linfa_decision_tree"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "decision_tree",
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
    model = "decision_tree",
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

