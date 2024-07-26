#' @export
print.linfa_fit <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}

#' @export
format.linfa_fit <- function(x, ...) {
  descr <- gsub("linfa_", "", class(x)[1])

  cli::cli_format_method({
    cli::cli_div(theme = list(span.lb = list(color = "blue")))
    cli::cli_text("A {.lb {descr}} fitted with linfa.")
  })
}
