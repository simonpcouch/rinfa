test_that("linfa_multinom_reg works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(1:4, 100, replace = TRUE)

  m_linfa <- linfa_multinom_reg(x, y)
  p_linfa <- predict(m_linfa, matrix(rnorm(12), ncol = 3))

  expect_s3_class(m_linfa, c("linfa_multinom_reg", "linfa_fit"))
  expect_type(p_linfa, "integer")
  expect_length(p_linfa, 4)
})


test_that("parsnip interface works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(1:4, 100, replace = TRUE)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- linfa_multinom_reg(x, y)
  p_linfa <- predict(m_linfa, newdata)

  m_parsnip <- fit(multinom_reg(engine = "linfa"), y ~ ., cbind(as.data.frame(x), y = as.factor(y)))
  p_parsnip <- predict(m_parsnip, as.data.frame(newdata))

  expect_s3_class(m_parsnip, c("_linfa_linear_reg", "model_fit"))
  expect_equal(p_linfa, as.integer(p_parsnip[[".pred_class"]]))
})
