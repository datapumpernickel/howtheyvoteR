#' Read a CSV from Cached GitHub Release
#'
#' This function ensures that the specified release tag is downloaded and unzipped
#' into the local cache directory. It then reads a CSV file from that cached data.
#'
#' @param file CSV filename (e.g. `"data.csv"`).
#' @param repo GitHub repository in `"owner/repo"` format. Default is `"HowTheyVote/data"`.
#' @param tag Release tag to read from. Defaults to `"latest"`.
#' @param dest Path to the cache directory. Defaults to `get_cache_dir()`.
#' @param verbose Logical; if `TRUE`, shows column type messages from `readr::read_csv()`.
#' @param ... Additional arguments passed to `readr::read_csv()`.
#'
#' @return A tibble or data.frame read from the specified CSV.
#' @export
htv_read_data <- function(file, repo = "HowTheyVote/data",
                          tag = "latest",
                         dest = get_cache_dir(),
                         verbose = F,
                         ...) {
  if (tag == "latest") tag <- get_release_tag(repo)
  tag_dir <- file.path(dest, tag)
  htv_get_data(repo = repo, tag = tag, dest = dest)  # ensure download
  csv_path <- file.path(tag_dir, file)
  if (!file.exists(csv_path)) {
    stop("CSV '", file, "' not found in cache for tag ", tag)
  }
  readr::read_csv(csv_path,show_col_types =verbose, ...)
}
