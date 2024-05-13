use extendr_api::prelude::*;
use extendr_api::wrapper::ExternalPtr;
use extendr_api::TryInto;
use linfa::prelude::Predict;
use linfa::traits::Fit;
use linfa::DatasetBase;
use linfa_datasets::diabetes;
use linfa_linear::FittedLinearRegression;
use linfa_linear::LinearRegression;
use ndarray::Array;
use ndarray::Array2;
use ndarray::ArrayBase;
use ndarray::Dim;
use ndarray::OwnedRepr;
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

/// Return string `"Hello world!"` to R.
// /// @export
// #[extendr]
// fn hello_world() -> &'static str {
//     "Hello world!"
// }

// /// Fit a linear regression model and return a pointer to it.
// /// @export
#[extendr]
fn fit_linear_reg_linfa() -> LinReg {
    let dataset = diabetes();
    let model = LinearRegression::default().fit(&dataset).unwrap();
    // print it out for funs
    rprintln!("{:?}", model);
    LinReg::from(model)
}

#[extendr]
fn predict_linear_reg_linfa(model: &LinReg) -> Doubles {
    let preds = model.model.predict(&diabetes());
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
