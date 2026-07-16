#' Calculate the accumulated distance to the outlet
#'
#' Calculates the distance from each stream reach to the outlet using
#' directed graphs.
#'
#' @param network \code{igraph} object representing the stream network (with edge weights)
#' @param outlet Vector of node IDs that represent the outlet
#' @param weight Name of the edge weight attribute (e.g. 'length_km')
#'
#' @return Named vector with accumulated distances to the outlet
#' @export
#'
#' @examples
#' g <- igraph::graph_from_edgelist(
#'   matrix(c("1", "2", "2", "3", "3", "4"), byrow = TRUE, ncol = 2),
#'   directed = TRUE
#' )
#' igraph::E(g)$length_km <- c(2, 3, 4)
#' calculate_outlet_distance(g, outlet = "4", weight = "length_km")
calculate_outlet_distance <- function(network, outlet, weight = "length_km") {
  if (!inherits(network, "igraph")) stop("network must be an igraph object")

  # Ensure vertices have names
  if (is.null(igraph::V(network)$name)) {
    igraph::V(network)$name <- as.character(seq_len(igraph::vcount(network)))
  }

  # Ensure the weight attribute is present on the edges
  if (is.null(igraph::E(network)$weight)) {
    if (!weight %in% igraph::edge_attr_names(network)) stop(paste0("Edge does not have attribute '", weight, "'"))
    igraph::E(network)$weight <- igraph::edge_attr(network, weight)
  }

  distances <- rep(Inf, igraph::vcount(network))
  names(distances) <- igraph::V(network)$name

  for (f in outlet) {
    d <- suppressWarnings(igraph::distances(network, v = f, mode = "in", weights = igraph::E(network)$weight))
    distances <- pmin(distances, d[1, ], na.rm = TRUE)
  }

  return(distances)
}
