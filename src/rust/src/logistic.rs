use extendr_api::prelude::*;
use linfa::prelude::Predict;
use linfa::traits::Fit;
use linfa::Dataset;
use linfa_logistic::FittedLogisticRegression;
use linfa_logistic::LogisticRegression;
use linfa_logistic::MultiFittedLogisticRegression;
use linfa_logistic::MultiLogisticRegression;
use ndarray::Array1;
use ndarray::Array2;

// two class (logistic_reg) ---------------------------------------------
pub struct linfa_logistic_reg {
    pub model: FittedLogisticRegression<f64, usize>,
}

#[extendr]
impl linfa_logistic_reg {}

impl From<FittedLogisticRegression<f64, usize>> for linfa_logistic_reg {
    fn from(value: FittedLogisticRegression<f64, usize>) -> Self {
        linfa_logistic_reg { model: value }
    }
}

#[extendr]
fn fit_logistic_reg(x: Vec<f64>, y: Vec<i32>, n_features: i32) -> linfa_logistic_reg {
    let n_features = n_features as usize;

    let x = Array2::from_shape_vec((n_features, x.len() / n_features), x)
        .expect("Failed to reshape x")
        .t()
        .to_owned();

    let y = Array1::from_vec(y.into_iter().map(|v| v as usize).collect());

    let dataset = Dataset::new(x, y)
        .with_feature_names((0..n_features).map(|i| format!("feature_{}", i)).collect());

    let model = LogisticRegression::default().fit(&dataset).unwrap();

    linfa_logistic_reg::from(model)
}

#[extendr]
fn predict_logistic_reg(model: &linfa_logistic_reg, x: Vec<f64>, n_features: i32) -> Integers {
    let n_features = n_features as usize;

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

// multi-class (multinom_reg) ------------------------------------------------
pub struct linfa_multinom_reg {
    pub model: MultiFittedLogisticRegression<f64, usize>,
}

#[extendr]
impl linfa_multinom_reg {}

impl From<MultiFittedLogisticRegression<f64, usize>> for linfa_multinom_reg {
    fn from(value: MultiFittedLogisticRegression<f64, usize>) -> Self {
        linfa_multinom_reg { model: value }
    }
}

#[extendr]
fn fit_multinom_reg(x: Vec<f64>, y: Vec<i32>, n_features: i32) -> linfa_multinom_reg {
    let n_features = n_features as usize;

    let x = Array2::from_shape_vec((n_features, x.len() / n_features), x)
        .expect("Failed to reshape x")
        .t()
        .to_owned();

    let y = Array1::from_vec(y.into_iter().map(|v| v as usize).collect());

    let dataset = Dataset::new(x, y)
        .with_feature_names((0..n_features).map(|i| format!("feature_{}", i)).collect());

    let model = MultiLogisticRegression::default().fit(&dataset).unwrap();

    linfa_multinom_reg::from(model)
}

#[extendr]
fn predict_multinom_reg(model: &linfa_multinom_reg, x: Vec<f64>, n_features: i32) -> Integers {
    let n_features = n_features as usize;

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
    mod logistic;
    fn fit_logistic_reg;
    fn predict_logistic_reg;
    fn fit_multinom_reg;
    fn predict_multinom_reg;
}
