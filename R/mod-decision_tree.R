#' Decision trees with linfa
#'
#' @description
#' This is an internal function that interfaces directly with the Rust
#' implementation from linfa. The preferred entry point is via tidymodels,
#' i.e. with:
#'
#' ```
#' model_spec <- decision_tree(engine = "linfa", mode = "classification")
#' model <- fit(model_spec, as.factor(vs) ~ ., mtcars)
#' ```
#'
#' @param x A numeric matrix of predictors.
#' @param y An integer vector of outcome values.
#' @inheritParams parsnip::decision_tree
#'
#' @examples
#' x <- matrix(rnorm(300), ncol = 3)
#' y <- sample(1:4, size = 100, replace = TRUE)
#'
#' m <- .linfa_decision_tree(x, y)
#' m
#'
#' predict(m, matrix(rnorm(12), ncol = 3))
#' @keywords internal
#' @export
.linfa_decision_tree <- function(x, y, cost_complexity = 0.00001,
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
      x,
      y,
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
predict.linfa_decision_tree <- function(object, newdata, ...) {
  predict_decision_tree(object$fit, newdata)
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
      func = c(pkg = "rinfa", fun = ".linfa_decision_tree"),
      defaults = list()
    )
  )

  parsnip::set_model_arg(
    model = "decision_tree",
    eng = "linfa",
    parsnip = "cost_complexity",
    original = "cost_complexity",
    func = list(pkg = "dials", fun = "cost_complexity"),
    has_submodel = FALSE
  )

  parsnip::set_model_arg(
    model = "decision_tree",
    eng = "linfa",
    parsnip = "min_n",
    original = "min_n",
    func = list(pkg = "dials", fun = "min_n"),
    has_submodel = FALSE
  )

  parsnip::set_model_arg(
    model = "decision_tree",
    eng = "linfa",
    parsnip = "tree_depth",
    original = "tree_depth",
    func = list(pkg = "dials", fun = "tree_depth"),
    has_submodel = FALSE
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

