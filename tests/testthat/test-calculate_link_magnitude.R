test_that("calculate_link_magnitude correctly computes Shreve values with a bifurcation", {
  g <- igraph::make_graph(edges = c("1", "3", "2", "3", "3", "4"), directed = TRUE)
  result <- calculate_link_magnitude(g)

  expect_equal(unname(result["1"]), 1)
  expect_equal(unname(result["2"]), 1)
  expect_equal(unname(result["3"]), 2)  # 1 + 1
  expect_equal(unname(result["4"]), 2)  # inherits everything from 3
})
