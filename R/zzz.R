# nocov start

# The functions below define the model information. These access the model
# environment inside of parsnip so they have to be executed once parsnip has
# been loaded.

.onLoad <- function(libname, pkgname) {
  make_decision_tree_linfa()
  make_linear_reg_linfa()
  make_logistic_reg_linfa()
  make_multinom_reg_linfa()
  make_naive_Bayes_linfa()
  make_svm_linear_linfa()
}


# nocov end
