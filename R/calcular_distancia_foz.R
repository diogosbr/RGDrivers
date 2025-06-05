#' Calcula a distância acumulada até a foz
#'
#' Esta função calcula a distância de cada trecho fluvial até a foz usando grafos direcionais.
#'
#' @param rede Objeto `igraph` representando a rede hidrográfica (com pesos nas arestas)
#' @param foz Vetor de IDs dos nós que representam a foz
#' @param peso Nome do atributo de peso nas arestas (ex: 'length_km')
#'
#' @return Vetor nomeado com distâncias acumuladas até a foz
#' @export
calcular_distancia_foz <- function(rede, foz, peso = "length_km") {
  if (!inherits(rede, "igraph")) stop("rede deve ser um objeto igraph")

  # Garante que os vértices têm nome
  if (is.null(V(rede)$name)) {
    V(rede)$name <- as.character(seq_len(vcount(rede)))
  }

  # Garante que o atributo de peso está presente nas arestas
  if (is.null(E(rede)$weight)) {
    if (!peso %in% edge_attr_names(rede)) stop(paste0("Aresta não tem atributo '", peso, "'"))
    E(rede)$weight <- edge_attr(rede, peso)
  }

  distancias <- rep(Inf, vcount(rede))
  names(distancias) <- V(rede)$name

  for (f in foz) {
    d <- suppressWarnings(distances(rede, v = f, mode = "in", weights = E(rede)$weight))
    distancias <- pmin(distancias, d[1, ], na.rm = TRUE)
  }

  return(distancias)
}
