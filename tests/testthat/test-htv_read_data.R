
test_that("htv_read_data() reads existing CSV from cache", {
  tmp <- local_tempdir()
  tag <- "v1.0.0"
  tag_dir <- file.path(tmp, tag)
  dir_create(tag_dir)

  # Create a dummy CSV
  csv_file <- "data.csv"
  data <- tibble(id = 1:3, name = c("Alice", "Bob", "Charlie"))
  write_csv(data, file.path(tag_dir, csv_file))

  stub(htv_read_data, "get_release_tag", tag)
  stub(htv_read_data, "htv_get_data", NULL)

  result <- htv_read_data(file = csv_file, tag = tag, dest = tmp)
  expect_equal(result, data)
})

test_that("htv_read_data() errors if CSV not found", {
  tmp <- local_tempdir()
  tag <- "v1.0.0"
  dir_create(file.path(tmp, tag))

  stub(htv_read_data, "get_release_tag", tag)
  stub(htv_read_data, "htv_get_data", NULL)

  expect_error(
    htv_read_data("missing.csv", tag = tag, dest = tmp),
    "CSV 'missing.csv' not found"
  )
})
