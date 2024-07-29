test_that("linfa_linear_reg works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- rnorm(100)

  m_linfa <- .linfa_linear_reg(x, y)
  p_linfa <- predict(m_linfa, matrix(rnorm(12), ncol = 3))

  expect_s3_class(m_linfa, c("linfa_linear_reg", "linfa_fit"))
  expect_type(p_linfa, "double")
  expect_length(p_linfa, 4)
})

test_that("linfa_linear_reg gives similar output to lm", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- rnorm(100)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- .linfa_linear_reg(x, y)
  p_linfa <- predict(m_linfa, newdata)

  m_r <- lm(y ~ ., cbind(as.data.frame(x), y))
  p_r <- predict(m_r, as.data.frame(newdata))

  expect_equal(unname(p_r), p_linfa)
})

test_that("parsnip interface works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- rnorm(100)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- .linfa_linear_reg(x, y)
  p_linfa <- predict(m_linfa, newdata)

  m_parsnip <- fit(linear_reg(engine = "linfa"), y ~ ., cbind(as.data.frame(x), y))
  p_parsnip <- predict(m_parsnip, as.data.frame(newdata))

  expect_s3_class(m_parsnip, c("_linfa_linear_reg", "model_fit"))
  expect_equal(p_linfa, p_parsnip[[".pred"]])
})
