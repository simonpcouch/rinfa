## Design of rinfa

rinfa is an R interface to the Rust machine learning library linfa.

The linfa crate is composed of several different modules, each implementing support for a given kind of model. For module `model1`, the code that "bridges" R and that linfa module is in `src/rust/src/model1.rs`. The `model1.rs` module will supply a (non-exported) `fit()` and `predict()` R function for the given model type, with names `fit_model_a()` and `predict_model_a()`, where `model_a` is the name of the "model type" in tidymodels that corresponds to the kind of model implemented in the linfa module. (There's not always a 1-to-1 relationship between `model1` and `model_a`.) `fit_model_a()` has an "XY" interface (i.e. numeric model matrix X, vector outcome Y). `fit_model1()` is the lowest-level R interface to `model1`, is not exported, and is not intended for use by end-users.

`fit_model_a()` is wrapped by an exported but `@keywords internal` function `.linfa_model_a()`, which also has an XY interface. `.linfa_model_a()` takes care of argument checking, calling the internal function, and putting together a classed R object. While this interface is exported, it should not be considered stable.

The "public" interface to rinfa models is via tidymodels (or, more specifically, parsnip). To use rinfa (and thus `.linfa_model_a()`) as a modeling engine, use the code `model_a(engine = "rinfa")`. Models can be fitted either with an XY interface (which will result in no `model.matrix()` overhead) or the formula interface.
