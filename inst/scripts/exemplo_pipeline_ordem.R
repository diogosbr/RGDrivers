# Script de exemplo: cálculo de Link Magnitude e D-LINK em rede hidrográfica
# Requer: terra, igraph, dplyr, RGDrivers

library(RGDrivers)
library(terra)
library(dplyr)

# 1. Carregar vetor de rede hidrográfica
rede <- terra::vect("dados/rede_trechos.gpkg")  # Substitua pelo seu caminho real

# 2. Criar grafo direcionado
grafo <- criar_grafo_rede(rede, col_id = "cotrecho", col_jus = "nutrjus")

# 3. Calcular Link Magnitude (Shreve)
link_mag <- calcular_link_magnitude(grafo)

# 4. Criar tabela base com atributos
tabela_rede <- as.data.frame(rede)
tabela_rede$link_mag <- link_mag[as.character(tabela_rede$cotrecho)]

# 5. Calcular D-LINK (link_mag do trecho jusante)
tabela_rede <- calcular_dlink(tabela_rede, col_id = "cotrecho", col_jus = "nutrjus", col_ordem = "link_mag")

# 6. Gravar SpatVector com colunas link_mag e D_LINK
gravar_rede_com_ordens(
  vetor_original = rede,
  df_atualizado = tabela_rede,
  col_id = "cotrecho",
  colunas_adicionais = c("link_mag", "D_LINK"),
  caminho_saida = "saida/rede_ordem_dlink.gpkg"
)
