

test_that("get_release_tag() returns latest tag online", {
  mock_gh <- mock(list(tag_name = "v1.2.3"))
  stub(get_release_tag, "gh::gh", mock_gh)
  stub(get_release_tag, "curl::has_internet", TRUE)

  expect_equal(get_release_tag("user/repo"), "v1.2.3")
})

test_that("get_release_tag() falls back to cache when offline", {
  stub(get_release_tag, "curl::has_internet", FALSE)
  stub(get_release_tag, "htv_list_cached_tags", function(...) c("v1.0.0", "v1.2.3"))

  expect_message(
    tag <- get_release_tag("user/repo"),
    "No internet"
  )
  expect_equal(tag, "v1.2.3")
})

test_that("get_release_tag() errors when offline and no cache", {
  stub(get_release_tag, "curl::has_internet", FALSE)
  stub(get_release_tag, "htv_list_cached_tags", function(...) character(0))

  expect_error(get_release_tag("user/repo"), "no cached data")
})

test_that("htv_get_data() downloads and unzips correctly", {
  tmp <- local_tempdir()
  mock_tag <- "v9.9.9"
  zip_path <- file.path(tmp, mock_tag, "export.zip")
  dir.create(file.path(tmp, mock_tag), recursive = TRUE)

  stub(htv_get_data, "get_release_tag", mock_tag)
  stub(htv_get_data, "piggyback::pb_download", function(...) {
    file.create(zip_path)
  })
  stub(htv_get_data, "utils::unzip", function(...) NULL)

  result <- htv_get_data(dest = tmp, overwrite = TRUE)
  expect_true(file.exists(zip_path))
  expect_equal(result$tag, mock_tag)
  expect_equal(result$path, file.path(tmp, mock_tag))
  expect_true(file.exists(file.path(tmp, mock_tag, ".unzipped")))
})

test_that("htv_delete_oldest_cached() deletes only oldest", {
  tmp <- local_tempdir()
  tags <- c("v1.0.0", "v1.1.0", "v2.0.0")
  paths <- file.path(tmp, tags)
  dir.create(paths[1], recursive = TRUE)
  dir.create(paths[2], recursive = TRUE)
  dir.create(paths[3], recursive = TRUE)

  deleted <- (htv_delete_oldest_cached(n = 2, path = tmp))
  expect_length(deleted, 2)
  expect_false(dir_exists(paths[1]))
  expect_false(dir_exists(paths[2]))
  expect_true(dir_exists(paths[3]))
})
