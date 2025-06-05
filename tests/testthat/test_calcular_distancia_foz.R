test_that("calcular_distancia_foz calcula corretamente", {
  g <- igraph::graph_from_edgelist(
    matrix(c("1", "2", "2", "3", "3", "4"), byrow = TRUE, ncol = 2),
    directed = TRUE
  )
  igraph::E(g)$length_km <- c(2, 3, 4)

  d <- calcular_distancia_foz(g, foz = "4", peso = "length_km")

  expect_equal(unname(d["1"]), 9)
  expect_equal(unname(d["2"]), 7)
  expect_equal(unname(d["3"]), 4)
  expect_equal(unname(d["4"]), 0)
})
