test_that("full stream order pipeline works with simulated data", {
  skip_if_not_installed("terra")
  skip_if_not_installed("igraph")

  library(terra)
  library(dplyr)

  # Create simulated reaches
  lines <- terra::vect(c(
    "LINESTRING(0 0, 1 1)",
    "LINESTRING(1 1, 2 2)",
    "LINESTRING(2 2, 3 3)"
  ), crs = "EPSG:4326")

  # Add simulated attributes
  lines$cotrecho <- c(1, 2, 3)
  lines$nutrjus <- c(2, 3, NA)

  # Create graph
  g <- create_network_graph(lines, col_id = "cotrecho", col_downstream = "nutrjus")

  # Link Magnitude
  lm <- calculate_link_magnitude(g)

  # Table with attributes
  df <- as.data.frame(lines)
  df$link_mag <- lm[as.character(df$cotrecho)]

  # D_LINK
  df <- calculate_dlink(df, col_id = "cotrecho", col_downstream = "nutrjus", col_order = "link_mag")

  # Assign back to the original vector
  lines$link_mag <- df$link_mag
  lines$D_LINK <- df$D_LINK

  # Checks
  expect_equal(lines$link_mag[1], 1)
  expect_equal(lines$D_LINK[1], 1)
  expect_equal(lines$link_mag[2], 1)
  expect_equal(lines$D_LINK[2], 1)
  expect_equal(lines$link_mag[3], 1)
  expect_true(is.na(lines$D_LINK[3]))  # last reach (no downstream)
})
