
test_that("htv_list_metadata() parses metadata JSON correctly", {
  tmp <- local_tempdir()
  tag <- "v2.0.0"
  tag_dir <- file.path(tmp, tag)
  dir_create(tag_dir)

  stub(htv_list_metadata, "get_release_tag", tag)
  stub(htv_list_metadata, "htv_get_data", NULL)

  json_path <- file.path(tag_dir, "data.csv-metadata.json")

  metadata <- list(
    url = "data.csv",
    `dc:created` = "2025-01-01",
    `dc:license` = list(`@id` = "https://creativecommons.org/licenses/by/4.0/"),
    tableSchema = list(
      columns = list(
        name = c("id", "name"),
        `dc:description` = c("Identifier", "Person name")
      )
    )
  )

  write_json(metadata, json_path, auto_unbox = TRUE, pretty = TRUE)

  result <- htv_list_metadata(tag = tag, dest = tmp)

  expect_s3_class(result, "tbl_df")
  expect_named(result, c("file", "created", "license", "description"))
  expect_equal(result$file, "data.csv")
  expect_equal(result$created, "2025-01-01")
  expect_equal(result$license, "https://creativecommons.org/licenses/by/4.0/")
  expect_equal(result$description[[1]]$name, c("id", "name"))
})
