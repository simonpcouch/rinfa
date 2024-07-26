#![allow(non_snake_case)]

use extendr_api::prelude::*;
use linfa::prelude::*;
use linfa_bayes::GaussianNb;
use ndarray::{Array1, Array2};

pub struct linfa_naive_Bayes {
    pub model: GaussianNb<f64, usize>,
}

#[extendr]
impl linfa_naive_Bayes {}

impl From<GaussianNb<f64, usize>> for linfa_naive_Bayes {
    fn from(value: GaussianNb<f64, usize>) -> Self {
        linfa_naive_Bayes { model: value }
    }
}

#[extendr]
pub fn fit_naive_Bayes(x: Vec<f64>, y: Vec<i32>, n_features: i32, var_smoothing: f64) -> linfa_naive_Bayes {
    let n_features = n_features as usize;

    // Convert Vec<f64> to Array2 for x
    let x = Array2::from_shape_vec((n_features, x.len() / n_features), x)
        .expect("Failed to reshape x")
        .t()
        .to_owned();

    // Convert Vec<i32> to Array1<usize> for y
    let y = Array1::from_vec(y.into_iter().map(|v| v as usize).collect());

    // Create a Dataset
    let dataset = Dataset::new(x, y)
        .with_feature_names((0..n_features).map(|i| format!("feature_{}", i)).collect());

    let model = GaussianNb::params()
        .var_smoothing(var_smoothing)
        .fit(&dataset)
        .unwrap();

    linfa_naive_Bayes::from(model)
}

#[extendr]
pub fn predict_naive_Bayes(model: &linfa_naive_Bayes, x: Vec<f64>, n_features: i32) -> Integers {
    let n_features = n_features as usize;

    // Convert Vec<f64> to Array2 for x
    let x = Array2::from_shape_vec((n_features, x.len() / n_features), x)
        .expect("Failed to reshape x")
        .t()
        .to_owned();

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
    mod bayes;
    fn fit_naive_Bayes;
    fn predict_naive_Bayes;
}
