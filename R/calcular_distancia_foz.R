#' Calcula a distancia acumulada ate a foz
#'
#' Esta funcao calcula a distancia de cada trecho fluvial ate a foz usando grafos direcionais.
#'
#' @param rede Objeto `igraph` representando a rede hidrografica (com pesos nas arestas)
#' @param foz Vetor de IDs dos nos que representam a foz
#' @param peso Nome do atributo de peso nas arestas (ex: 'length_km')
#'
#' @return Vetor nomeado com distancias acumuladas ate a foz
#' @export
#'
#' @examples
#' g <- igraph::graph_from_edgelist(
#'   matrix(c("1", "2", "2", "3", "3", "4"), byrow = TRUE, ncol = 2),
#'   directed = TRUE
#' )
#' igraph::E(g)$length_km <- c(2, 3, 4)
#' calcular_distancia_foz(g, foz = "4", peso = "length_km")
calcular_distancia_foz <- function(rede, foz, peso = "length_km") {
  if (!inherits(rede, "igraph")) stop("rede deve ser um objeto igraph")

  # Garante que os vertices tem nome
  if (is.null(igraph::V(rede)$name)) {
    igraph::V(rede)$name <- as.character(seq_len(igraph::vcount(rede)))
  }

  # Garante que o atributo de peso esta presente nas arestas
  if (is.null(igraph::E(rede)$weight)) {
    if (!peso %in% igraph::edge_attr_names(rede)) stop(paste0("Aresta nao tem atributo '", peso, "'"))
    igraph::E(rede)$weight <- igraph::edge_attr(rede, peso)
  }

  distancias <- rep(Inf, igraph::vcount(rede))
  names(distancias) <- igraph::V(rede)$name

  for (f in foz) {
    d <- suppressWarnings(igraph::distances(rede, v = f, mode = "in", weights = igraph::E(rede)$weight))
    distancias <- pmin(distancias, d[1, ], na.rm = TRUE)
  }

  return(distancias)
}
