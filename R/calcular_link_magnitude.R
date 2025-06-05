#' Calcula o Link Magnitude (Shreve) para uma rede hidrográfica
#'
#' Esta função calcula o Link Magnitude (também conhecido como ordem de Shreve) para cada trecho de uma rede hidrográfica,
#' assumindo que a rede está representada como um grafo acíclico direcionado (DAG).
#' O Link Magnitude de um trecho corresponde ao número total de caminhos independentes desde as nascentes até aquele trecho,
#' somando os valores dos predecessores de cada nó.
#'
#' @param grafo Objeto \code{igraph} direcionado representando a rede hidrográfica (deve ser um DAG).
#'
#' @return Um vetor nomeado de inteiros, indicando o Link Magnitude de cada nó (trecho) da rede.
#'
#' @examples
#' g <- igraph::make_graph(edges = c("1", "2", "2", "3", "3", "4"), directed = TRUE)
#' calcular_link_magnitude(g)
#'
#' @export
calcular_link_magnitude <- function(grafo) {
  if (!inherits(grafo, "igraph")) stop("grafo deve ser um objeto 'igraph'")
  if (!igraph::is_dag(grafo)) stop("grafo deve ser acíclico (DAG)")

  ordem <- igraph::topo_sort(grafo, mode = "out") |> names()
  link_mag <- rep(NA_integer_, igraph::vcount(grafo))
  names(link_mag) <- igraph::V(grafo)$name

  for (v in ordem) {
    preds <- igraph::neighbors(grafo, v, mode = "in") |> names()
    link_mag[v] <- if (length(preds) == 0) 1L else sum(link_mag[preds])
  }
  return(link_mag)
}
