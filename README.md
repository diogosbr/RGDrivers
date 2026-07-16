
# RGDrivers

<!-- badges: start -->

![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
[![License:
MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
<!-- badges: end -->

R package for stream network analysis, focused on connectivity
metrics, order calculation (such as Link Magnitude), and spatial
manipulation integrated with `terra`, `igraph`, and `sf`.

------------------------------------------------------------------------

## Installation

``` r
# Development version via GitHub
# install.packages("devtools")
devtools::install_github("diogosbr/RGDrivers")
```

------------------------------------------------------------------------

## Quick example

This example uses a small set of fictional line reaches included in
the package.

``` r
library(RGDrivers)
library(terra)

# 1. Load sample data
network <- vect(system.file("extdata/rede_exemplo.gpkg", package = "RGDrivers"))

# 2. Create graph
g <- create_network_graph(network, col_id = "id", col_downstream = "jus")

# 3. Calculate Link Magnitude
lm <- calculate_link_magnitude(g)

# 4. Add to data.frame
df <- as.data.frame(network)
df$link_mag <- lm[as.character(df$id)]
df <- calculate_dlink(df, col_id = "id", col_downstream = "jus", col_order = "link_mag")

# 5. Assign back to the vector
network$link_mag <- df$link_mag
network$D_LINK <- df$D_LINK

# 6. Plot the result
plot(network, col = network$link_mag, main = "Link Magnitude")
```

------------------------------------------------------------------------

## Main functions

- `create_network_graph()` – creates a graph from reach data
- `calculate_link_magnitude()` – calculates the Shreve order
- `calculate_dlink()` – obtains the downstream reach order
- `write_network_with_orders()` – saves a vector with orders
- `create_stream_network()` – creates a graph directly from `sf` reaches
- `calculate_outlet_distance()` – accumulated distance to the outlet

------------------------------------------------------------------------

## License

This package is licensed under the terms of the MIT license.
