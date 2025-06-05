#' Calcula Link Magnitude (Shreve) de uma rede hidrográfica
#'
#' Esta função calcula o Link Magnitude (ordem de Shreve) para cada trecho da rede fluvial,
#' assumindo que a rede é um grafo acíclico direcionado (DAG).
#'
#' @param grafo Objeto `igraph` direcionado representando a rede hidrográfica
#'
#' @return Vetor nomeado com valores inteiros de link magnitude para cada nó
#' @export
#'
#' @examples
#' g <- igraph::make_graph(edges = c("1", "2", "2", "3", "3", "4"), directed = TRUE)
#' calcular_link_magnitude(g)
calcular_link_magnitude <- function(grafo) {
  if (!inherits(grafo, "igraph")) {
    stop("grafo deve ser um objeto 'igraph'")
  }
  if (!igraph::is_dag(grafo)) {
    stop("grafo deve ser acíclico (DAG)")
  }

  ordem <- igraph::topo_sort(grafo, mode = "out") |> names()

  link_mag <- rep(NA_integer_, igraph::vcount(grafo))
  names(link_mag) <- igraph::V(grafo)$name

  for (v in ordem) {
    preds <- igraph::neighbors(grafo, v, mode = "in") |> names()
    link_mag[v] <- if (length(preds) == 0) 1 else sum(link_mag[preds])
  }

  return(link_mag)
}
