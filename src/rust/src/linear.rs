use extendr_api::prelude::*;
use linfa::prelude::Predict;
use linfa::traits::Fit;
use linfa::Dataset;
use linfa_linear::FittedLinearRegression;
use linfa_linear::LinearRegression;
use ndarray::Array1;
use ndarray::Array2;

pub struct linfa_linear_reg {
    pub model: FittedLinearRegression<f64>,
}

#[extendr]
impl linfa_linear_reg {}

impl From<FittedLinearRegression<f64>> for linfa_linear_reg {
    fn from(value: FittedLinearRegression<f64>) -> Self {
        linfa_linear_reg { model: value }
    }
}

#[extendr]
fn fit_linear_reg(x: ArrayView2<f64>, y: ArrayView1<f64>) -> linfa_linear_reg {
    // Convert inputs to linfa-happy formats
    let x: Array2<f64> = x.to_owned();
    let y: Array1<f64> = y.to_owned();

    // Create a Dataset
    let dataset = Dataset::new(x, y);

    let model = LinearRegression::default().fit(&dataset).unwrap();

    linfa_linear_reg::from(model)
}

#[extendr]
fn predict_linear_reg(model: &linfa_linear_reg, x: ArrayView2<f64>) -> Doubles {
    let x: Array2<f64> = x.to_owned();

    let preds = model.model.predict(&x);
    let preds = preds.into_raw_vec();
    Doubles::from_values(preds)
}

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod linear;
    fn fit_linear_reg;
    fn predict_linear_reg;
}
