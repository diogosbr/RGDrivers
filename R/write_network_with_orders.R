#' Write a spatial vector with stream order columns
#'
#' Inserts new columns (e.g. \code{link_mag}, \code{D_LINK}) into a
#' \code{SpatVector} object from an updated \code{data.frame} and writes it to
#' disk.
#'
#' @param original_vector Original \code{SpatVector} object (stream network)
#' @param updated_df Data frame containing the reach IDs and the new columns
#' @param col_id Name of the column with the unique reach identifier (e.g. "cotrecho")
#' @param additional_cols Vector with the names of the columns to add to the vector
#' @param output_path Full path to save the file to (e.g. "output.gpkg")
#' @param overwrite Logical, if TRUE allows overwriting an existing file
#'
#' @return NULL (writes file to disk)
#' @export
#'
#' @examples
#' # Hypothetical example
#' # write_network_with_orders(vector, updated_df, "id", c("link_mag", "D_LINK"), "output.gpkg")
write_network_with_orders <- function(original_vector, updated_df, col_id, additional_cols, output_path, overwrite = TRUE) {
  if (!inherits(original_vector, "SpatVector")) {
    stop("original_vector must be an object of type 'SpatVector'")
  }

  for (column in additional_cols) {
    values <- updated_df[[column]]
    names_vec <- as.character(updated_df[[col_id]])
    original_vector[[column]] <- values[match(original_vector[[col_id]], names_vec)]
  }

  terra::writeVector(original_vector, output_path, overwrite = overwrite)
}
