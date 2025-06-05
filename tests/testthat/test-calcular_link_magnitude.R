test_that("calcular_link_magnitude calcula corretamente valores de Shreve com bifurcação", {
  g <- igraph::make_graph(edges = c("1", "3", "2", "3", "3", "4"), directed = TRUE)
  resultado <- calcular_link_magnitude(g)

  expect_equal(unname(resultado["1"]), 1)
  expect_equal(unname(resultado["2"]), 1)
  expect_equal(unname(resultado["3"]), 2)  # 1 + 1
  expect_equal(unname(resultado["4"]), 2)  # herda tudo de 3
})
