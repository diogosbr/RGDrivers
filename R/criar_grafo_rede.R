#' Cria grafo direcionado a partir de rede fluvial
#'
#' Esta função constrói um grafo `igraph` a partir de um objeto `sf` ou `SpatVector` contendo trechos fluviais.
#' É necessário que existam colunas com IDs únicos dos trechos e seus respectivos trechos jusantes.
#'
#' @param rede Objeto `sf` ou `SpatVector` representando os trechos da rede hidrográfica
#' @param col_id Nome da coluna com o ID único de cada trecho
#' @param col_jus Nome da coluna com o ID do trecho jusante
#'
#' @return Objeto `igraph` direcionado representando a rede hidrográfica
#' @export
#'
#' @examples
#' library(igraph)
#' library(sf)
#' linhas <- st_sfc(
#'   st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
#' )
#' dados <- data.frame(id = c(1, 2, 3), jus = c(2, 3, NA))
#' rede <- st_sf(dados, geometry = linhas)
#' g <- criar_grafo_rede(rede, col_id = "id", col_jus = "jus")
#' plot(g)
criar_grafo_rede <- function(rede, col_id, col_jus) {
  if (!inherits(rede, c("sf", "SpatVector"))) {
    stop("O objeto deve ser do tipo 'sf' ou 'SpatVector'")
  }

  df <- if (inherits(rede, "SpatVector")) as.data.frame(rede) else st_drop_geometry(rede)

  edges <- df |>
    dplyr::select(from = dplyr::all_of(col_id), to = dplyr::all_of(col_jus)) |>
    dplyr::filter(!is.na(from) & !is.na(to)) |>
    dplyr::mutate(across(everything(), as.character))

  grafo <- igraph::graph_from_data_frame(edges, directed = TRUE, vertices = unique(df[[col_id]]))

  if (!igraph::is_dag(grafo)) {
    stop("A rede contém ciclos. O grafo não é DAG (grafo acíclico direcionado).")
  }

  return(grafo)
}
