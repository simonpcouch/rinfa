use extendr_api::prelude::*;
use linfa::traits::Fit;
use linfa::prelude::Predict;
use linfa_linear::LinearRegression;
use linfa_linear::FittedLinearRegression;
use linfa_datasets::diabetes;
use extendr_api::wrapper::ExternalPtr;
use extendr_api::TryInto;
use linfa::DatasetBase;
use ndarray::Array;
use ndarray::Array2;
use ndarray::ArrayBase;
use ndarray::OwnedRepr;
use ndarray::Dim;
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

/// Return string `"Hello world!"` to R.
/// @export
#[extendr]
fn hello_world() -> &'static str {
    "Hello world!"
}

/// Fit a linear regression model and return a pointer to it.
/// @export
#[extendr]
fn fit_linear_reg_linfa() -> ExternalPtr<FittedLinearRegression<f64>> {
    let dataset = diabetes();
    let model = LinearRegression::default().fit(&dataset).unwrap();

    let model_deferred = DeferredDeref::new(model);

    ExternalPtr::new(model)
}



/// Given a pointer to a model and data, return predictions from the model.
/// @export
#[extendr]
fn predict_linear_reg_linfa(pointer: ExternalPtr<FittedLinearRegression<f64>>) -> Robj {
    let model: FittedLinearRegression<f64> = pointer.try_into().unwrap();
    // let model: FittedLinearRegression<f64> = unsafe {*pointer};
    let pred: Vec<f64> = model.predict(&diabetes()).into_raw_vec();
    // let robj: Robj = pointer.into();
    // let model: FittedLinearRegression<f64> = robj.try_into();
    // let pred: Vec<f64> = model.predict(&diabetes()).into_raw_vec();

    // pred
    r!(pred)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod rinfa;
    fn fit_linear_reg_linfa;
    fn predict_linear_reg_linfa;
    fn hello_world;
}
