test_that("`check_x()` works", {
  expect_snapshot(error = TRUE, check_newdata(data.frame(), ptype1))
  expect_snapshot(error = TRUE, check_x(matrix(1:12, ncol = 3), y = 1:4))
  expect_snapshot(error = TRUE, check_x(matrix(rnorm(12), ncol = 3), y = 1:3))

  expect_no_condition(check_x(matrix(rnorm(12), ncol = 3), y = 1:4))
})

test_that("`check_y()` works", {
  expect_snapshot(error = TRUE, check_y(1:10, "regression"))
  expect_snapshot(error = TRUE, check_y(rnorm(10), "classification"))
  expect_snapshot(error = TRUE, check_y(1:10, "boop"))

  expect_no_condition(check_y(1:10, "classification"))
  expect_no_condition(check_y(rnorm(10), "regression"))
})


test_that("`check_newdata()` works", {
  ptype1 <- matrix(1:12, ncol = 3)[0,]

  expect_snapshot(error = TRUE, check_newdata(data.frame(), ptype1))
  expect_snapshot(error = TRUE, check_newdata(matrix(1:12, ncol = 4), ptype1))
  expect_snapshot(error = TRUE, check_newdata(matrix(rnorm(12), ncol = 4), ptype1))

  expect_no_condition(check_newdata(matrix(rnorm(12), ncol = 3), ptype1))
})
