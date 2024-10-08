use extendr_api::prelude::*;
use linfa::Dataset;
use linfa::prelude::Predict;
use linfa::traits::Fit;
use linfa_svm::Svm;
use ndarray::{Array1, Array2};

pub struct linfa_svm_linear {
    pub model: Svm<f64, bool>,
}

#[extendr]
impl linfa_svm_linear {}

impl From<Svm<f64, bool>> for linfa_svm_linear {
    fn from(value: Svm<f64, bool>) -> Self {
        linfa_svm_linear { model: value }
    }
}

#[extendr]
fn fit_svm_linear(x: ArrayView2<f64>, y: Vec<i32>, c: f64) -> linfa_svm_linear {
    let x: Array2<f64> = x.to_owned();

    let y = Array1::from_vec(y.into_iter().map(|v| v > 0).collect());

    let dataset = Dataset::new(x, y);

    let model = Svm::<f64, bool>::params()
        .linear_kernel()
        .pos_neg_weights(c, c)
        .fit(&dataset)
        .unwrap();

    linfa_svm_linear::from(model)
}

#[extendr]
fn predict_svm_linear(model: &linfa_svm_linear, x: ArrayView2<f64>) -> Integers {
    let x: Array2<f64> = x.to_owned();

    let preds = model.model.predict(&x);

    let preds_i32: Vec<i32> = preds.into_raw_vec().into_iter()
        .map(|x| x as i32)
        .collect();

    Integers::from_values(preds_i32)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod svm;
    fn fit_svm_linear;
    fn predict_svm_linear;
}
