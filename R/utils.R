#' Get the Latest Release Tag from GitHub
#'
#' @param repo GitHub repository in the format "owner/repo"
#'
#' @return A character string with the latest release tag
get_release_tag <- function(repo = "HowTheyVote/data") {
  release_info <- gh::gh("GET /repos/{owner}/{repo}/releases/latest",
                         owner = strsplit(repo, "/")[[1]][1],
                         repo = strsplit(repo, "/")[[1]][2])
  release_info$tag_name
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

  to_delete <- head(sort(tags), n)
  full_paths <- file.path(path, to_delete)
  unlink(full_paths, recursive = TRUE, force = TRUE)
  invisible(full_paths)
}
