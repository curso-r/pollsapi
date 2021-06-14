test_that("vector_to_options_list", {
  options_list <- vector_to_options_list(1:2)
  expect_identical(options_list, list(list(text = 1L), list(text = 2L)))
})


# Sys.setenv(POLLSAPI_KEY = "WH6QP71XS0413TN1BFGSE24Q52XE")
new_poll <- polls_create_poll(
  paste0("Is this a test? created at", Sys.time()),
  c("Yes", "No", "Maybe"),
  identifier = "test"
)

new_poll_content <- httr::content(new_poll)

test_that("polls_create_poll", {
  expect_identical(new_poll$status_code, 200L)
})

test_that("pollsapi_get_poll_by_id", {
  poll_by_id <- pollsapi_get_poll_by_id(poll_id = new_poll_content$data$id)
  expect_identical(poll_by_id$status_code, 200L)
})

test_that("pollsapi_get_all_polls", {
  all_polls <- pollsapi_get_all_polls()
  expect_identical(all_polls$status_code, 200L)
})

test_that("pollsapi_get_polls_by_identifier", {
  all_test_polls <- pollsapi_get_polls_by_identifier("test")
  expect_identical(all_test_polls$status_code, 200L)
})

test_that("pollsapi_create_vote and pollsapi_get_vote_by_id", {
  vote_created <- pollsapi_create_vote(
    poll_id = new_poll_content$data$id,
    option_id = new_poll_content$data$options[[1]]$id,
    identifier = "voted"
  )
  expect_identical(vote_created$status_code, 200L)

  vote_created_content <- httr::content(vote_created)

  vote <- pollsapi_get_vote_by_id(
    vote_id = vote_created_content$data$id
  )
  expect_identical(vote$status_code, 200L)
})

test_that("pollsapi_get_all_votes_on_a_poll", {
  all_votes <- pollsapi_get_all_votes_on_a_poll(poll_id = new_poll_content$data$id)
  expect_identical(all_votes$status_code, 200L)
})

test_that("pollsapi_get_all_votes_with_identifier", {
  all_test_votes <- pollsapi_get_all_votes_with_identifier("voted")
  expect_identical(all_test_votes$status_code, 200L)
})

test_that("pollsapi_remove_vote", {
  all_votes <- pollsapi_get_all_votes_on_a_poll(poll_id = new_poll_content$data$id)
  all_votes_content <- httr::content(all_votes)
  vote_removed <- pollsapi_remove_vote(all_votes_content$data$docs[[1]]$id)
  expect_identical(vote_removed$status_code, 200L)
})

test_that("pollsapi_remove_poll", {
  poll_removed <- pollsapi_remove_poll(poll_id = new_poll_content$data$id)
  expect_identical(poll_removed$status_code, 200L)
})
