test_that("create_stream_network works correctly with and without length", {
  library(sf)

  # Create a sample sf object with 3 connected lines
  reaches <- data.frame(
    cotrecho = c(1, 2, 3),
    nutrjus = c(2, 3, NA),
    length = c(0.5, 1.2, 2.0)
  )

  # Fake geometry just to satisfy sf
  lines <- st_sfc(
    st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
  )

  sf_reaches <- st_sf(reaches, geometry = lines)

  # Run function without weights
  g <- create_stream_network(sf_reaches, col_id = "cotrecho", col_downstream = "nutrjus")

  expect_s3_class(g, "igraph")
  expect_true(igraph::is_dag(g))
  expect_equal(igraph::vcount(g), 3)
  expect_equal(igraph::ecount(g), 2)
  expect_true("2" %in% igraph::neighbors(g, "1", mode = "out")$name)

  # Run function with weights
  g2 <- create_stream_network(sf_reaches, col_length = "length")
  expect_equal(igraph::E(g2)$length_km, c(0.5, 1.2))
})
