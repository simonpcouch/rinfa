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
    let x_owned: Array2<f64> = x.to_owned();
    let y_owned: Array1<f64> = y.to_owned();

    // Create a Dataset
    let dataset = Dataset::new(x_owned, y_owned);

    let model = LinearRegression::default().fit(&dataset).unwrap();

    linfa_linear_reg::from(model)
}

#[extendr]
fn predict_linear_reg(model: &linfa_linear_reg, x: Vec<f64>, n_features: i32) -> Doubles {
    let n_features = n_features as usize;

    // Convert Vec<f64> to Array2 for x
    let x = Array2::from_shape_vec((n_features, x.len() / n_features), x)
        .expect("Failed to reshape x")
        .t()
        .to_owned();

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
