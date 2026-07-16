#' Create a directed graph from a stream network
#'
#' Builds an \code{igraph} graph from an \code{sf} or \code{SpatVector} object
#' containing stream reaches. Requires columns with unique reach IDs and their
#' respective downstream reach IDs.
#'
#' @param network \code{sf} or \code{SpatVector} object representing the stream network reaches
#' @param col_id Name of the column with the unique ID of each reach
#' @param col_downstream Name of the column with the downstream reach ID
#'
#' @return Directed \code{igraph} object representing the stream network
#' @export
#'
#' @importFrom rlang .data
#'
#' @examples
#' library(igraph)
#' library(sf)
#' lines <- st_sfc(
#'   st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
#' )
#' data <- data.frame(id = c(1, 2, 3), downstream = c(2, 3, NA))
#' network <- st_sf(data, geometry = lines)
#' g <- create_network_graph(network, col_id = "id", col_downstream = "downstream")
#' plot(g)
create_network_graph <- function(network, col_id, col_downstream) {
  if (!inherits(network, c("sf", "SpatVector"))) {
    stop("The object must be of type 'sf' or 'SpatVector'")
  }

  df <- if (inherits(network, "SpatVector")) as.data.frame(network) else sf::st_drop_geometry(network)

  edges <- df |>
    dplyr::select(from = dplyr::all_of(col_id), to = dplyr::all_of(col_downstream)) |>
    dplyr::filter(!is.na(.data$from) & !is.na(.data$to)) |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.character))

  # collect all reach and downstream IDs, removing NAs
  vertices <- unique(c(df[[col_id]], df[[col_downstream]]))
  vertices <- vertices[!is.na(vertices)]

  graph <- igraph::graph_from_data_frame(edges,
                                          directed = TRUE,
                                          vertices = vertices)

  if (!igraph::is_dag(graph)) {
    stop("The network contains cycles. The graph is not a DAG (directed acyclic graph).")
  }

  return(graph)
}
