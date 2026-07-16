#' Salva um vetor espacial com colunas de ordem fluvial
#'
#' Esta funcao insere novas colunas (ex: `link_mag`, `D_LINK`) em um objeto `SpatVector`
#' a partir de um `data.frame` atualizado e o grava em disco.
#'
#' @param vetor_original Objeto `SpatVector` original (rede hidrografica)
#' @param df_atualizado Data frame contendo os IDs dos trechos e as colunas novas
#' @param col_id Nome da coluna de identificacao unica dos trechos (ex: "cotrecho")
#' @param colunas_adicionais Vetor com os nomes das colunas que serao adicionadas ao vetor
#' @param caminho_saida Caminho completo para salvar o arquivo (ex: "saida.gpkg")
#' @param overwrite Logico, se TRUE permite sobrescrever o arquivo existente
#'
#' @return NULL (salva arquivo no disco)
#' @export
#'
#' @examples
#' # Exemplo hipotetico
#' # gravar_rede_com_ordens(vetor, df_atualizado, "id", c("link_mag", "D_LINK"), "saida.gpkg")
gravar_rede_com_ordens <- function(vetor_original, df_atualizado, col_id, colunas_adicionais, caminho_saida, overwrite = TRUE) {
  if (!inherits(vetor_original, "SpatVector")) {
    stop("vetor_original deve ser um objeto do tipo 'SpatVector'")
  }

  for (coluna in colunas_adicionais) {
    valores <- df_atualizado[[coluna]]
    nomes <- as.character(df_atualizado[[col_id]])
    vetor_original[[coluna]] <- valores[match(vetor_original[[col_id]], nomes)]
  }

  terra::writeVector(vetor_original, caminho_saida, overwrite = overwrite)
}
