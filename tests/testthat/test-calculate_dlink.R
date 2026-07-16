test_that("calculate_dlink returns correct D_LINK with ids and orders", {
  df <- data.frame(
    id = c(1, 2, 3),
    downstream = c(2, 3, NA),
    order = c(5, 10, 20)
  )

  result <- calculate_dlink(df, col_id = "id", col_downstream = "downstream", col_order = "order")

  expect_equal(result$D_LINK[1], 10)
  expect_equal(result$D_LINK[2], 20)
  expect_true(is.na(result$D_LINK[3]))  # NA because it has no downstream reach
})
