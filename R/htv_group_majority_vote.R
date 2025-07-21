#' Calculate Group-Level Majority Vote
#'
#' This function calculates the majority position per group and vote,
#' excluding "DID_NOT_VOTE" entries. Ties are retained (can be filtered separately).
#' Data is read internally via `htv_read_data()`. If not present, data is downloaded.
#'
#' @param tag Optional release tag for the dataset (passed to `htv_read_data()`). Defaults to "latest".
#'
#' @return A tibble with one row per group per vote, including majority position, share, total votes, and tie count.
#' @export
htv_group_majority_vote <- function(tag = "latest") {
  votes <- htv_read_data("votes.csv", tag = tag)
  member_votes <- htv_read_data("member_votes.csv", tag = tag)

  base <- member_votes |>
    dplyr::filter(position != "DID_NOT_VOTE") |>
    dplyr::count(vote_id, group_code, name = "total_votes")

  majority_vote <- member_votes |>
    dplyr::filter(position != "DID_NOT_VOTE") |>
    dplyr::count(vote_id, group_code, position) |>
    dplyr::group_by(vote_id, group_code) |>
    dplyr::mutate(total_votes = sum(n)) |>
    dplyr::slice_max(order_by = n, n = 1, with_ties = TRUE) |>
    dplyr::mutate(majority_perc = n / total_votes * 100) |>
    dplyr::left_join(votes |> dplyr::transmute(vote_id = id, timestamp), by = "vote_id") |>
    dplyr::ungroup()

  ties <- majority_vote |>
    dplyr::count(vote_id, group_code) |>
    dplyr::filter(n > 1)

  majority_vote_clean <- majority_vote |>
    dplyr::anti_join(ties, by = c("vote_id", "group_code"))

  base |>
    dplyr::left_join(majority_vote_clean |>
                       dplyr::select(vote_id, group_code, position, majority_perc, timestamp),
                     by = c("vote_id", "group_code")) |>
    dplyr::mutate(tied = dplyr::if_else(is.na(position), TRUE, FALSE))
}
