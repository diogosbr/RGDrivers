#' Calcula o Link Magnitude (Shreve) para uma rede hidrografica
#'
#' Esta funcao calcula o Link Magnitude (tambem conhecido como ordem de Shreve) para cada trecho de uma rede hidrografica,
#' assumindo que a rede esta representada como um grafo aciclico direcionado (DAG).
#' O Link Magnitude de um trecho corresponde ao numero total de caminhos independentes desde as nascentes ate aquele trecho,
#' somando os valores dos predecessores de cada no.
#'
#' @param grafo Objeto \code{igraph} direcionado representando a rede hidrografica (deve ser um DAG).
#'
#' @return Um vetor nomeado de inteiros, indicando o Link Magnitude de cada no (trecho) da rede.
#'
#' @examples
#' g <- igraph::make_graph(edges = c("1", "2", "2", "3", "3", "4"), directed = TRUE)
#' calcular_link_magnitude(g)
#'
#' @export
calcular_link_magnitude <- function(grafo) {
  if (!inherits(grafo, "igraph")) stop("grafo deve ser um objeto 'igraph'")
  if (!igraph::is_dag(grafo)) stop("grafo deve ser aciclico (DAG)")

  ordem <- igraph::topo_sort(grafo, mode = "out") |> names()
  link_mag <- rep(NA_integer_, igraph::vcount(grafo))
  names(link_mag) <- igraph::V(grafo)$name

  for (v in ordem) {
    preds <- igraph::neighbors(grafo, v, mode = "in") |> names()
    link_mag[v] <- if (length(preds) == 0) 1L else sum(link_mag[preds])
  }
  return(link_mag)
}
