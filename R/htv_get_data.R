#' Download and Unzip GitHub Release Asset (if needed)
#'
#' @param repo GitHub repository in the format "owner/repo"
#' @param tag GitHub release tag. Defaults to "latest"
#' @param dest Directory to store extracted contents. Defaults to user cache dir.
#' @param overwrite Logical. Should existing files be overwritten?
#' @param ... Additional arguments passed to `pb_download()`
#'
#' @return A character vector of extracted file paths
#' @export
htv_get_data <- function(
    repo = "HowTheyVote/data",
    tag = "latest",
    dest = get_cache_dir(),
    overwrite = FALSE,
    ...
) {
  if (tag == "latest") {
    tag <- get_release_tag(repo)
  }

  tag_dir <- file.path(dest, tag)
  if (!dir.exists(tag_dir)) {
    dir.create(tag_dir, recursive = TRUE)
  }

  zip_path <- file.path(tag_dir, "export.zip")

  # If file doesn't exist or overwrite is TRUE, download it
  if (!file.exists(zip_path) || overwrite) {
    piggyback::pb_download(
      file = "export.zip",
      repo = repo,
      tag = tag,
      dest = tag_dir,
      overwrite = overwrite,
      ...
    )
  }

  # Only unzip if export.zip exists and has not been unzipped yet
  marker <- file.path(tag_dir, ".unzipped")
  if (!file.exists(marker) || overwrite) {
    unzip(zip_path, exdir = tag_dir)
    file.create(marker)
  }

  invisible(list(tag = tag, path = tag_dir))
}
