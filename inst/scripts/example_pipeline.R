# Example script: calculating Link Magnitude and D-LINK for a stream network
# Requires: terra, igraph, dplyr, RGDrivers

library(RGDrivers)
library(terra)
library(dplyr)

# 1. Load the stream network vector
network <- terra::vect("data/rede_trechos.gpkg")  # Replace with your actual path

# 2. Create the directed graph
graph <- create_network_graph(network, col_id = "cotrecho", col_downstream = "nutrjus")

# 3. Calculate Link Magnitude (Shreve)
link_mag <- calculate_link_magnitude(graph)

# 4. Create base table with attributes
network_table <- as.data.frame(network)
network_table$link_mag <- link_mag[as.character(network_table$cotrecho)]

# 5. Calculate D-LINK (link_mag of the downstream reach)
network_table <- calculate_dlink(network_table, col_id = "cotrecho", col_downstream = "nutrjus", col_order = "link_mag")

# 6. Write SpatVector with the link_mag and D_LINK columns
write_network_with_orders(
  original_vector = network,
  updated_df = network_table,
  col_id = "cotrecho",
  additional_cols = c("link_mag", "D_LINK"),
  output_path = "output/rede_ordem_dlink.gpkg"
)
