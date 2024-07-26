#![allow(non_camel_case_types)]

mod bayes;
mod linear;
mod logistic;
mod svm;
mod trees;

use extendr_api::prelude::*;

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod rinfa;
    use bayes;
    use linear;
    use logistic;
    use svm;
    use trees;
}
