test_that("linfa_logistic_reg works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(1:2, 100, replace = TRUE)

  m_linfa <- .linfa_logistic_reg(x, y)
  p_linfa <- predict(m_linfa, matrix(rnorm(12), ncol = 3))

  expect_s3_class(m_linfa, c("linfa_logistic_reg", "linfa_fit"))
  expect_type(p_linfa, "integer")
  expect_length(p_linfa, 4)
})

test_that("linfa_logistic_reg gives similar output to glm", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(0:1, 100, replace = TRUE)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- .linfa_logistic_reg(x, y)
  p_linfa <- predict(m_linfa, newdata)

  m_r <- glm(y ~ ., "binomial", cbind(as.data.frame(x), y))
  p_r <- predict(m_r, as.data.frame(newdata), type = "response")

  expect_equal(unname(p_r > .5), as.logical(p_linfa))
})

test_that("parsnip interface works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(0:1, 100, replace = TRUE)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- .linfa_logistic_reg(x, y)
  p_linfa <- predict(m_linfa, newdata)

  m_parsnip <- fit(logistic_reg(engine = "linfa"), y ~ ., cbind(as.data.frame(x), y = as.factor(y)))
  p_parsnip <- predict(m_parsnip, as.data.frame(newdata))

  expect_s3_class(m_parsnip, c("_linfa_linear_reg", "model_fit"))
  expect_equal(p_linfa, as.integer(p_parsnip[[".pred_class"]]) - 1)
})
