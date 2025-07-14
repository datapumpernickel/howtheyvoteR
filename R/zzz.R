.onAttach <- function(libname, pkgname) {
  path <- get_cache_dir()
  if (!dir.exists(path)) dir.create(path, recursive = TRUE)

  tags <- htv_list_cached_tags(path)
  n_tags <- length(tags)

  if (n_tags > 1 && interactive()) {
    cli::cli_alert_warning("Cache contains {n_tags} release versions.")
    cli::cli_code("howtheyvoteR::htv_delete_oldest_cached(n = 1)")
  }
}
