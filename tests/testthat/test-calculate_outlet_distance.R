test_that("calculate_outlet_distance computes distances correctly", {
  g <- igraph::graph_from_edgelist(
    matrix(c("1", "2", "2", "3", "3", "4"), byrow = TRUE, ncol = 2),
    directed = TRUE
  )
  igraph::E(g)$length_km <- c(2, 3, 4)

  d <- calculate_outlet_distance(g, outlet = "4", weight = "length_km")

  expect_equal(unname(d["1"]), 9)
  expect_equal(unname(d["2"]), 7)
  expect_equal(unname(d["3"]), 4)
  expect_equal(unname(d["4"]), 0)
})
