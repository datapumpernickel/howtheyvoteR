#' Get the Latest Release Tag from GitHub or Fallback to Cache
#'
#' Attempts to retrieve the latest release tag from the specified GitHub repository.
#' If no internet connection is available, the function falls back to the most
#' recently cached release tag, if available. A warning is issued in that case.
#'
#' @param repo GitHub repository in the format "owner/repo". Defaults to "HowTheyVote/data".
#'
#' @return A character string with the latest release tag. If offline, the most recent cached tag.
#' @export
#'
#' @examples
#' \dontrun{
#' get_release_tag()        # Online mode or fallback to cache
#' }
get_release_tag <- function(repo = "HowTheyVote/data") {
  if (curl::has_internet()) {
    release_info <- gh::gh("GET /repos/{owner}/{repo}/releases/latest",
                           owner = strsplit(repo, "/")[[1]][1],
                           repo  = strsplit(repo, "/")[[1]][2])
    return(release_info$tag_name)
  }

  # Offline fallback
  cached_tags <- htv_list_cached_tags()
  if (length(cached_tags) == 0) {
    cli::cli_abort("No internet connection and no cached data available.")
  }

  fallback_tag <- sort(cached_tags, decreasing = TRUE)[1]
  cli::cli_alert_warning("No internet. Using cached tag: {.strong {fallback_tag}}")
  return(fallback_tag)
}


#' Get Path to Package Cache Directory
#'
#' Optionally overridden with HOWTHEYVOTER_CACHE_DIR env variable.
#'
#' @return A character string path
#' @export
get_cache_dir <- function() {
  custom <- Sys.getenv("HOWTHEYVOTER_CACHE_DIR")
  if (nzchar(custom)) return(custom)
  tools::R_user_dir("howtheyvoteR", which = "cache")
}

#' List All Cached Tags
#'
#' @param path Base cache path
#' @return A character vector of cached tag directory names
#' @export
htv_list_cached_tags <- function(path = get_cache_dir()) {
  list.dirs(path, full.names = FALSE, recursive = FALSE)
}

#' Delete N Oldest Cached Tags (by Sorted Name)
#'
#' @param n Number of oldest tags to delete
#' @param path Cache base directory
#'
#' @return Invisibly returns deleted paths
#' @export
htv_delete_oldest_cached <- function(n = 2, path = get_cache_dir()) {
  tags <- list.dirs(path, full.names = FALSE, recursive = FALSE)
  if (length(tags) <= n) return(invisible())

  to_delete <- utils::head(sort(tags), n)
  full_paths <- file.path(path, to_delete)
  unlink(full_paths, recursive = TRUE, force = TRUE)
  cli::cli_inform("Deleted oldest cached tags: {.strong {to_delete}}")
  invisible(full_paths)
}
