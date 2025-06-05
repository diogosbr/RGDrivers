test_that("calcular_dlink retorna D_LINK correto com ids e ordens", {
  df <- data.frame(
    id = c(1, 2, 3),
    jus = c(2, 3, NA),
    ordem = c(5, 10, 20)
  )

  resultado <- calcular_dlink(df, col_id = "id", col_jus = "jus", col_ordem = "ordem")

  expect_equal(resultado$D_LINK[1], 10)
  expect_equal(resultado$D_LINK[2], 20)
  expect_true(is.na(resultado$D_LINK[3]))  # NA pois não tem jusante
})
