#' Calculate the D-LINK value (downstream reach order)
#'
#' Adds a \code{D_LINK} column to a table of stream reaches, representing the
#' order value (e.g. Link Magnitude) of the downstream reach.
#'
#' @param df Data frame containing the stream network reaches
#' @param col_id Name of the column with the unique reach ID (e.g. "cotrecho")
#' @param col_downstream Name of the column with the downstream reach ID (e.g. "nutrjus")
#' @param col_order Name of the column with the reach order (e.g. "link_mag", "order", etc.)
#'
#' @return The same \code{df}, with a new \code{D_LINK} column
#' @export
#'
#' @importFrom rlang :=
#'
#' @examples
#' df <- data.frame(
#'   id = c(1, 2, 3),
#'   downstream = c(2, 3, NA),
#'   order = c(1, 2, 3)
#' )
#' calculate_dlink(df, col_id = "id", col_downstream = "downstream", col_order = "order")
calculate_dlink <- function(df, col_id, col_downstream, col_order) {
  col_order_downstream <- paste0(col_order, "_downstream")

  df_out <- dplyr::left_join(
    df,
    df |>
      dplyr::select(!!rlang::sym(col_id), !!rlang::sym(col_order)) |>
      dplyr::rename(!!col_order_downstream := !!rlang::sym(col_order)),
    by = stats::setNames(col_id, col_downstream)
  )

  df_out$D_LINK <- df_out[[col_order_downstream]]
  return(df_out)
}
