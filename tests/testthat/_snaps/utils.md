# `check_x()` works

    Code
      check_newdata(data.frame(), ptype1)
    Condition
      Error:
      ! `newdata` must be a numeric matrix.

---

    Code
      check_x(matrix(1:12, ncol = 3), y = 1:4)
    Condition
      Error:
      ! `x` must be a numeric matrix.

---

    Code
      check_x(matrix(rnorm(12), ncol = 3), y = 1:3)
    Condition
      Error:
      ! `x` must have as many rows as `y` has values.

# `check_y()` works

    Code
      check_y(1:10, "regression")
    Condition
      Error:
      ! `y` must be an integer.

---

    Code
      check_y(rnorm(10), "classification")
    Condition
      Error:
      ! `y` must be an integer.

---

    Code
      check_y(1:10, "boop")
    Condition
      Error:
      ! `mode` must be one of "regression" or "classification".

# `check_newdata()` works

    Code
      check_newdata(data.frame(), ptype1)
    Condition
      Error:
      ! `newdata` must be a numeric matrix.

---

    Code
      check_newdata(matrix(1:12, ncol = 4), ptype1)
    Condition
      Error:
      ! `newdata` must be a numeric matrix.

---

    Code
      check_newdata(matrix(rnorm(12), ncol = 4), ptype1)
    Condition
      Error in `check_newdata()`:
      ! `newdata` must have as many columns as the training data.
      i `newdata` has 4, the training data had 3.

