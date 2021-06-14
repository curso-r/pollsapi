
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pollsapi

R client for Polls API service. See [API documentations
here](https://docs.pollsapi.com/).

## Installation

``` r
remotes::install_github("curso-r/pollsapi")
```

## Example

``` r
# Look for your API key on Polls API web site
# Sys.setenv(POLLSAPI_KEY = "WH6QP71XS0413TN1BFGSE24Q52XE")
```

``` r
new_poll <- polls_create_poll(
  paste0("Is this a test? created at", Sys.time()),
  c("Yes", "No", "Maybe"),
  identifier = "test"
)
new_poll_content <- httr::content(new_poll)

poll_by_id <- pollsapi_get_poll_by_id(poll_id = new_poll_content$data$id)
all_polls <- pollsapi_get_all_polls()
all_test_polls <- pollsapi_get_polls_by_identifier("test")

vote_created <- pollsapi_create_vote(
  poll_id = new_poll_content$data$id,
  option_id = new_poll_content$data$options[[1]]$id,
  identifier = "voted"
)
vote_created_content <- httr::content(vote_created)
vote <- pollsapi_get_vote_by_id(vote_id = vote_created_content$data$id)
all_votes <- pollsapi_get_all_votes_on_a_poll(poll_id = new_poll_content$data$id)
all_test_votes <- pollsapi_get_all_votes_with_identifier("voted")
all_votes_content <- httr::content(all_votes)

vote_removed <- pollsapi_remove_vote(all_votes_content$data$docs[[1]]$id)
poll_removed <- pollsapi_remove_poll(poll_id = new_poll_content$data$id)
```
