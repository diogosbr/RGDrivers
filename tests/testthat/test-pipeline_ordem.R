test_that("pipeline completo de ordem fluvial funciona com dados simulados", {
  skip_if_not_installed("terra")
  skip_if_not_installed("igraph")

  library(terra)
  library(dplyr)

  # Criar trechos simulados
  linhas <- terra::vect(c(
    "LINESTRING(0 0, 1 1)",
    "LINESTRING(1 1, 2 2)",
    "LINESTRING(2 2, 3 3)"
  ), crs = "EPSG:4326")

  # Adicionar atributos simulados
  linhas$cotrecho <- c(1, 2, 3)
  linhas$nutrjus <- c(2, 3, NA)

  # Criar grafo
  g <- criar_grafo_rede(linhas, col_id = "cotrecho", col_jus = "nutrjus")

  # Link Magnitude
  lm <- calcular_link_magnitude(g)

  # Tabela com atributos
  df <- as.data.frame(linhas)
  df$link_mag <- lm[as.character(df$cotrecho)]

  # D_LINK
  df <- calcular_dlink(df, col_id = "cotrecho", col_jus = "nutrjus", col_ordem = "link_mag")

  # Atribuição ao vetor original
  linhas$link_mag <- df$link_mag
  linhas$D_LINK <- df$D_LINK

  # Verificações
  expect_equal(linhas$link_mag[1], 1)
  expect_equal(linhas$D_LINK[1], 1)
  expect_equal(linhas$link_mag[2], 1)
  expect_equal(linhas$D_LINK[2], 1)
  expect_equal(linhas$link_mag[3], 1)
  expect_true(is.na(linhas$D_LINK[3]))  # último trecho (sem jusante)
})
