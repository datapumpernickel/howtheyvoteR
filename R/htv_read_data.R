#' Read a CSV from cached release
#'
#' @param file CSV filename (e.g. "data.csv")
#' @param repo GitHub repo "owner/repo"
#' @param tag Release tag ("latest" by default)
#' @param dest Cache dir (defaults via get_cache_dir())
#' @param ... Passed to readr::read_csv
#' @return A tibble or data.frame
#' @export
htv_read_data <- function(file, repo = "HowTheyVote/data",
                          tag = "latest",
                         dest = get_cache_dir(), ...) {
  if (tag == "latest") tag <- get_release_tag(repo)
  tag_dir <- file.path(dest, tag)
  htv_get_data(repo = repo, tag = tag, dest = dest)  # ensure download
  csv_path <- file.path(tag_dir, file)
  if (!file.exists(csv_path)) {
    stop("CSV '", file, "' not found in cache for tag ", tag)
  }
  readr::read_csv(csv_path, ...)
}
