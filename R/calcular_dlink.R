#' Calcula o valor D-LINK (ordem do trecho jusante)
#'
#' Esta funcao adiciona a uma tabela de trechos fluviais a coluna `D_LINK`, que representa
#' o valor da ordem (ex: Link Magnitude) do trecho jusante.
#'
#' @param df Data frame contendo os trechos da rede hidrografica
#' @param col_id Nome da coluna com ID unico dos trechos (ex: "cotrecho")
#' @param col_jus Nome da coluna com o ID do trecho jusante (ex: "nutrjus")
#' @param col_ordem Nome da coluna com a ordem do trecho (ex: "link_mag", "ordem", etc.)
#'
#' @return O mesmo `df`, com uma nova coluna `D_LINK`
#' @export
#'
#' @importFrom rlang :=
#'
#' @examples
#' df <- data.frame(
#'   id = c(1, 2, 3),
#'   jus = c(2, 3, NA),
#'   ordem = c(1, 2, 3)
#' )
#' calcular_dlink(df, col_id = "id", col_jus = "jus", col_ordem = "ordem")
calcular_dlink <- function(df, col_id, col_jus, col_ordem) {
  col_ordem_jus <- paste0(col_ordem, "_jus")

  df_out <- dplyr::left_join(
    df,
    df |>
      dplyr::select(!!rlang::sym(col_id), !!rlang::sym(col_ordem)) |>
      dplyr::rename(!!col_ordem_jus := !!rlang::sym(col_ordem)),
    by = stats::setNames(col_id, col_jus)
  )

  df_out$D_LINK <- df_out[[col_ordem_jus]]
  return(df_out)
}
