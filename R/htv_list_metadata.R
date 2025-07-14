#' Get Metadata Summary for Latest Tag
#'
#' @param repo GitHub repository in the format "owner/repo"
#' @param dest Base destination directory
#'
#' @return A tibble with one row per CSV file and nested metadata for each column
#' @export
htv_list_metadata <- function(repo = "HowTheyVote/data", dest = get_cache_dir(), tag = "latest") {
  if (tag == "latest") tag <- get_release_tag(repo)
  tag_dir <- file.path(dest, tag)

  # ensure data is downloaded and unzipped
  htv_get_data(repo = repo, tag = tag, dest = dest)

  # find metadata json files
  json_files <- list.files(tag_dir, pattern = "\\.csv-metadata\\.json$", full.names = TRUE)

  purrr::map_dfr(json_files, function(path) {
    meta <- jsonlite::read_json(path, simplifyVector = TRUE)

    tibble::tibble(
      file = meta$url,
      created = meta$`dc:created`,
      license = meta$`dc:license`$`@id`,
      description = list(
        tibble::tibble(
          name = meta$tableSchema$columns$name,
          description = meta$tableSchema$columns$`dc:description`
        )
      )
    )
  })
}
