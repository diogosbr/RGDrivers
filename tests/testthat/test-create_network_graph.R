test_that("create_network_graph works with an sf object and simple ids", {
  library(sf)
  lines <- st_sfc(
    st_linestring(matrix(c(0, 0, 1, 1), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(1, 1, 2, 2), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(2, 2, 3, 3), ncol = 2, byrow = TRUE))
  )
  network <- st_sf(id = c(1, 2, 3), downstream = c(2, 3, NA), geometry = lines)

  g <- create_network_graph(network, col_id = "id", col_downstream = "downstream")

  expect_s3_class(g, "igraph")
  expect_true(igraph::is_dag(g))
  expect_equal(igraph::vcount(g), 3)
  expect_equal(igraph::ecount(g), 2)
})
