use extendr_api::prelude::*;
use linfa::prelude::Predict;
use linfa::traits::Fit;
use linfa::Dataset;
use linfa_linear::FittedLinearRegression;
use linfa_linear::LinearRegression;
use ndarray::Array1;
use ndarray::Array2;
use std::ops::Deref;

// Define a wrapper struct that holds the value and implements Deref
struct DeferredDeref<T>(Box<T>);

impl<T> DeferredDeref<T> {
    // Constructor function to create a DeferredDeref instance
    fn new(value: T) -> Self {
        DeferredDeref(Box::new(value))
    }
}

// Implement Deref for DeferredDeref
impl<T> Deref for DeferredDeref<T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

pub struct LinReg {
    pub model: FittedLinearRegression<f64>,
}

#[extendr]
impl LinReg {}

impl From<FittedLinearRegression<f64>> for LinReg {
    fn from(value: FittedLinearRegression<f64>) -> Self {
        LinReg { model: value }
    }
}

/// Fit a linear regression model and return a pointer to it.
/// @export
#[extendr]
fn fit_linear_reg_linfa(x: Vec<f64>, y: Vec<f64>, n_features: i32) -> LinReg {
    let n_features = n_features as usize;

    // Convert Vec<f64> to Array2 for x
    let x = Array2::from_shape_vec((x.len() / n_features, n_features), x)
        .expect("Failed to reshape x");

    // Convert Vec<f64> to Array1 for y
    let y = Array1::from(y);

    // Create a Dataset
    let dataset = Dataset::new(x, y)
        .with_feature_names((0..n_features).map(|i| format!("feature_{}", i)).collect());

    let model = LinearRegression::default().fit(&dataset).unwrap();

    LinReg::from(model)
}

#[extendr]
/// @export
fn predict_linear_reg_linfa(model: &LinReg, x: Vec<f64>, n_features: i32) -> Doubles {
    let n_features = n_features as usize;

    // Convert Vec<f64> to Array2 for x
    let x = Array2::from_shape_vec((x.len() / n_features, n_features), x)
        .expect("Failed to reshape x");

    let preds = model.model.predict(&x);
    let preds = preds.into_raw_vec();
    Doubles::from_values(preds)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod rinfa;
    fn fit_linear_reg_linfa;
    fn predict_linear_reg_linfa;
    // fn hello_world;
}
