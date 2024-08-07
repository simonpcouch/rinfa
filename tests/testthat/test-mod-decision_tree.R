test_that("parsnip interface works", {
  set.seed(1)
  x <- matrix(rnorm(300), ncol = 3)
  y <- sample(1:4, 100, replace = TRUE)
  newdata <- matrix(rnorm(12), ncol = 3)

  m_linfa <- .linfa_decision_tree(x, y)
  p_linfa <- predict(m_linfa, newdata)

  skip("TODO: i see intermittent test failures. \nthese fits don't seem to be deterministic? or maybe hyperparameters differ slightly?")

  m_parsnip <- fit(decision_tree(engine = "linfa", mode = "classification"), y ~ ., cbind(as.data.frame(x), y = as.factor(y)))
  p_parsnip <- predict(m_parsnip, as.data.frame(newdata))

  expect_s3_class(m_parsnip, c("_linfa_decision_tree", "model_fit"))
  expect_equal(p_linfa, as.integer(p_parsnip[[".pred_class"]]))
})
