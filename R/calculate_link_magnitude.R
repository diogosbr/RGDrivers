#' Calculate Link Magnitude (Shreve order) for a stream network
#'
#' Calculates the Link Magnitude (also known as Shreve stream order) for each
#' reach of a stream network, assuming the network is represented as a
#' directed acyclic graph (DAG). The Link Magnitude of a reach corresponds to
#' the total number of independent paths from the headwaters to that reach,
#' summing the values of its predecessors.
#'
#' @param graph Directed \code{igraph} object representing the stream network
#'   (must be a DAG).
#'
#' @return A named integer vector with the Link Magnitude of each node (reach)
#'   in the network.
#'
#' @examples
#' g <- igraph::make_graph(edges = c("1", "2", "2", "3", "3", "4"), directed = TRUE)
#' calculate_link_magnitude(g)
#'
#' @export
calculate_link_magnitude <- function(graph) {
  if (!inherits(graph, "igraph")) stop("graph must be an 'igraph' object")
  if (!igraph::is_dag(graph)) stop("graph must be acyclic (DAG)")

  topo_order <- igraph::topo_sort(graph, mode = "out") |> names()
  link_mag <- rep(NA_integer_, igraph::vcount(graph))
  names(link_mag) <- igraph::V(graph)$name

  for (v in topo_order) {
    preds <- igraph::neighbors(graph, v, mode = "in") |> names()
    link_mag[v] <- if (length(preds) == 0) 1L else sum(link_mag[preds])
  }
  return(link_mag)
}
