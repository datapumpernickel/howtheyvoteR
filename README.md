
<!-- README.md is generated from README.Rmd. Please edit that file -->

# howtheyvoteR

The `howtheyvoteR` package provides a lightweight interface to access,
download, and inspect the latest datasets from
[HowTheyVote.eu](https://howtheyvote.eu/). These datasets include
roll-call votes, member metadata, and more—published weekly and openly
by the dedicated HowTheyVote team.

## 🔍 What is HowTheyVote.eu?

> **HowTheyVote.eu** makes vote results of the European Parliament
> transparent and accessible – for citizens, journalists, and activists.
> The European Union is one of the largest democracies in the world. The
> European Parliament, with its 720 members from the EU’s 27 member
> states, represents just over 440 million Europeans. Although the
> Parliament publishes information such as agendas, minutes, and vote
> results on its website, it can be quite difficult to find out what
> MEPs voted on or how a particular vote turned out. HowTheyVote.eu
> compiles voting data from various official sources and allows anyone
> to search for votes and view the results.

We want to sincerely thank the team behind HowTheyVote.eu for their
consistent, careful work in publishing this valuable data. 🙌

## 📦 What this package does

- Downloads the latest published dataset as a zip archive
- Caches it locally by GitHub release tag
- Unzips and indexes metadata
- Allows you to inspect the structure of CSV files and read them into R

## 🚀 Example

``` r
library(howtheyvoteR)

# Download latest data release (cached by date tag)
htv_get_data()

# View available metadata
htv_list_metadata()

# Read a specific file from the cache
votes <- htv_read_csv("votes.csv")
```

## 📁 Caching behavior

Downloads are stored using the release tag (e.g., `2025-07-14`) in a
user cache directory (via `tools::R_user_dir()`). You can inspect and
manage the cache:

``` r
# List cached tags
htv_list_cached_tags()

# Delete old releases
htv_delete_oldest_cached(n = 2)
```

## 🛠️ Acknowledgements

- Data is provided under the [Open Data Commons Open Database License
  (ODbL)](https://opendatacommons.org/licenses/odbl/1-0/) by
  [HowTheyVote.eu](https://howtheyvote.eu)
- This package is not affiliated with HowTheyVote.eu, but built with
  gratitude for their open data release

For more details or to explore the raw dataset, visit the
[HowTheyVote/data GitHub
repository](https://github.com/HowTheyVote/data).

## 📬 Feedback

If you encounter issues in the dataset itself, please use the [official
HowTheyVote feedback form](https://howtheyvote.eu/). For bugs or
suggestions related to this package, feel free to open an issue here.
