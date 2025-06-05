#' Cria grafo direcionado a partir de trechos fluviais
#'
#' A função constrói um objeto `igraph` a partir de um `sf` de trechos fluviais com colunas de ID e jusante.
#'
#' @param sf_trechos Objeto `sf` com geometrias lineares e colunas de ID (`col_id`) e jusante (`col_jus`)
#' @param col_id Nome da coluna com ID do trecho (ex: "cotrecho")
#' @param col_jus Nome da coluna com ID do trecho jusante (ex: "nutrjus")
#' @param col_comprimento (Opcional) Nome da coluna com comprimento da linha, usado como peso
#'
#' @return Objeto `igraph` direcionado
#' @export
#'
#' @examples
#' library(sf)
#' linhas <- st_sfc(
#'   st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
#' )
#'
#' dados <- data.frame(
#'   cotrecho = c(1, 2, 3),
#'   nutrjus = c(2, 3, NA),
#'   comprimento = c(0.5, 1.2, 2.0)
#' )
#'
#' sf_trechos <- st_sf(dados, geometry = linhas)
#'
#' g <- criar_rede_hidrografica(sf_trechos, col_id = "cotrecho", col_jus = "nutrjus", col_comprimento = "comprimento")
#' plot(g)
criar_rede_hidrografica <- function(sf_trechos, col_id = "cotrecho", col_jus = "nutrjus", col_comprimento = NULL) {
  stopifnot("sf" %in% class(sf_trechos))
  ids <- sf_trechos[[col_id]]
  jus <- sf_trechos[[col_jus]]

  arestas <- na.omit(data.frame(from = ids, to = jus))
  g <- igraph::graph_from_data_frame(arestas, directed = TRUE, vertices = ids)

  if (!is.null(col_comprimento)) {
    comprimentos <- sf_trechos[[col_comprimento]]
    idx <- match(paste(arestas$from, arestas$to),
                 paste(sf_trechos[[col_id]], sf_trechos[[col_jus]]))
    igraph::E(g)$length_km <- comprimentos[idx]
  }

  return(g)
}
