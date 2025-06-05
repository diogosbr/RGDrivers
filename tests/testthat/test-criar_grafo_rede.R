test_that("criar_grafo_rede funciona com objeto sf e ids simples", {
  library(sf)
  linhas <- st_sfc(
    st_linestring(matrix(c(0, 0, 1, 1), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(1, 1, 2, 2), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(2, 2, 3, 3), ncol = 2, byrow = TRUE))
  )
  rede <- st_sf(id = c(1, 2, 3), jus = c(2, 3, NA), geometry = linhas)

  g <- criar_grafo_rede(rede, col_id = "id", col_jus = "jus")

  expect_s3_class(g, "igraph")
  expect_true(igraph::is_dag(g))
  expect_equal(igraph::vcount(g), 3)
  expect_equal(igraph::ecount(g), 2)
})
