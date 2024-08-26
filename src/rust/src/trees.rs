use extendr_api::prelude::*;
use linfa::prelude::*;
use linfa_trees::DecisionTree;
use ndarray::{Array1, Array2};

pub struct linfa_decision_tree {
    pub model: DecisionTree<f64, usize>,
}

#[extendr]
impl linfa_decision_tree {}

impl From<DecisionTree<f64, usize>> for linfa_decision_tree {
    fn from(value: DecisionTree<f64, usize>) -> Self {
        linfa_decision_tree { model: value }
    }
}

#[extendr]
pub fn fit_decision_tree(x: ArrayView2<f64>, y: Vec<i32>,
                         min_impurity_decrease: f64,
                         max_depth: i32, min_weight_split: f32) -> linfa_decision_tree {
    let x: Array2<f64> = x.to_owned();

    // Convert Vec<i32> to Array1<usize> for y
    let y = Array1::from_vec(y.into_iter().map(|v| v as usize).collect());

    // Create a Dataset
    let dataset = Dataset::new(x, y);

    let model = DecisionTree::params()
        .max_depth(Some(max_depth as usize))
        .min_weight_split(min_weight_split)
        .min_impurity_decrease(min_impurity_decrease)
        .fit(&dataset)
        .unwrap();

    linfa_decision_tree::from(model)
}

#[extendr]
pub fn predict_decision_tree(model: &linfa_decision_tree, x: ArrayView2<f64>) -> Integers {
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
    mod trees;
    fn fit_decision_tree;
    fn predict_decision_tree;
}
