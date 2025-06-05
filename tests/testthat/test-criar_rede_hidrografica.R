test_that("criar_rede_hidrografica funciona corretamente com e sem comprimento", {
  library(sf)

  # Criar um objeto sf de exemplo com 3 linhas conectadas
  trechos <- data.frame(
    cotrecho = c(1, 2, 3),
    nutrjus = c(2, 3, NA),
    comprimento = c(0.5, 1.2, 2.0)
  )

  # Geometria fake só pra satisfazer o sf
  linhas <- st_sfc(
    st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
    st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
  )

  sf_trechos <- st_sf(trechos, geometry = linhas)

  # Rodar função sem pesos
  g <- criar_rede_hidrografica(sf_trechos, col_id = "cotrecho", col_jus = "nutrjus")

  expect_s3_class(g, "igraph")
  expect_true(igraph::is_dag(g))
  expect_equal(igraph::vcount(g), 3)
  expect_equal(igraph::ecount(g), 2)
  expect_true("2" %in% igraph::neighbors(g, "1", mode = "out")$name)

  # Rodar função com pesos
  g2 <- criar_rede_hidrografica(sf_trechos, col_comprimento = "comprimento")
  expect_equal(igraph::E(g2)$length_km, c(0.5, 1.2))
})
