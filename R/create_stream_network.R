#' Create a directed graph from stream reaches
#'
#' Builds an \code{igraph} object from an \code{sf} object of stream reaches
#' with ID and downstream ID columns.
#'
#' @param sf_reaches \code{sf} object with line geometries and ID (\code{col_id})
#'   and downstream (\code{col_downstream}) columns
#' @param col_id Name of the column with the reach ID (e.g. "cotrecho")
#' @param col_downstream Name of the column with the downstream reach ID (e.g. "nutrjus")
#' @param col_length (Optional) Name of the column with line length, used as edge weight
#'
#' @return Directed \code{igraph} object
#' @export
#'
#' @examples
#' library(sf)
#' lines <- st_sfc(
#'   st_linestring(matrix(c(0,0, 1,1), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(1,1, 2,2), ncol = 2, byrow = TRUE)),
#'   st_linestring(matrix(c(2,2, 3,3), ncol = 2, byrow = TRUE))
#' )
#'
#' data <- data.frame(
#'   cotrecho = c(1, 2, 3),
#'   nutrjus = c(2, 3, NA),
#'   length = c(0.5, 1.2, 2.0)
#' )
#'
#' sf_reaches <- st_sf(data, geometry = lines)
#'
#' g <- create_stream_network(
#'   sf_reaches,
#'   col_id = "cotrecho",
#'   col_downstream = "nutrjus",
#'   col_length = "length"
#' )
#' plot(g)
create_stream_network <- function(sf_reaches, col_id = "cotrecho", col_downstream = "nutrjus", col_length = NULL) {
  stopifnot("sf" %in% class(sf_reaches))
  ids <- sf_reaches[[col_id]]
  downstream <- sf_reaches[[col_downstream]]

  edges <- stats::na.omit(data.frame(from = ids, to = downstream))
  g <- igraph::graph_from_data_frame(edges, directed = TRUE, vertices = ids)

  if (!is.null(col_length)) {
    lengths <- sf_reaches[[col_length]]
    idx <- match(paste(edges$from, edges$to),
                 paste(sf_reaches[[col_id]], sf_reaches[[col_downstream]]))
    igraph::E(g)$length_km <- lengths[idx]
  }

  return(g)
}
