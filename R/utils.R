check_x <- function(x, y, call = caller_env()) {
  if (!inherits(x, "matrix") || typeof(x) != "double") {
    cli::cli_abort(
      "{.arg x} must be a numeric matrix.",
      call = call
    )
  }

  if (!isTRUE(nrow(x) == length(y))) {
    cli::cli_abort(
      "{.arg x} must have as many rows as {.arg y} has values.",
      call = call
    )
  }

  invisible()
}

check_newdata <- function(newdata, ptype, call = caller_env()) {
  if (!inherits(newdata, "matrix") || typeof(newdata) != "double") {
    cli::cli_abort(
      "{.arg newdata} must be a numeric matrix.",
      call = call
    )
  }

  if (ncol(newdata) != ncol(ptype)) {
    cli::cli_abort(c(
      "{.arg newdata} must have as many columns as the training data.",
      "i" = "{.arg newdata} has {ncol(newdata)}, the training data had {ncol(ptype)}."
    )
    )
  }
}

check_y <- function(y, mode, call = caller_env()) {
  switch(
    mode,
    regression = check_numeric(y, call = call),
    classification = check_outcome(y, call = call),
    cli::cli_abort(
      "{.arg mode} must be one of {.val regression} or {.val classification}.",
      call = call
    )
  )
}

check_numeric <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!inherits(x, "numeric")) {
    cli::cli_abort("{.arg {arg}} must be an integer.", call = call)
  }
}

check_integer <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!inherits(x, "integer")) {
    cli::cli_abort("{.arg {arg}} must be an integer.", call = call)
  }
}

check_outcome <- function(x, arg = caller_arg(x), call = caller_env()) {
  if (!inherits_any(x, c("integer", "factor"))) {
    cli::cli_abort("{.arg {arg}} must be an integer or factor.", call = call)
  }
}
