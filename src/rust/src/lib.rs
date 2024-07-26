#![allow(non_camel_case_types)]

mod linear;
mod trees;

use extendr_api::prelude::*;
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

// Macro to generate exports.
// This ensures exported functions are registered with R.
// See corresponding C code in `entrypoint.c`.
extendr_module! {
    mod rinfa;
    use linear;
    use trees;
}
