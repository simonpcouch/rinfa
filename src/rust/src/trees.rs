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
pub fn fit_decision_tree(x: Vec<f64>, y: Vec<i32>, n_features: i32,
                         min_impurity_decrease: f64,
                         max_depth: i32, min_weight_split: f32) -> linfa_decision_tree {
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

    let model = DecisionTree::params()
        .max_depth(Some(max_depth as usize))
        .min_weight_split(min_weight_split)
        .min_impurity_decrease(min_impurity_decrease)
        .fit(&dataset)
        .unwrap();

    linfa_decision_tree::from(model)
}

#[extendr]
pub fn predict_decision_tree(model: &linfa_decision_tree, x: Vec<f64>, n_features: i32) -> Integers {
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
    mod trees;
    fn fit_decision_tree;
    fn predict_decision_tree;
}
