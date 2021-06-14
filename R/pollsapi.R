#' @keywords internal
base_url <- function() {
  "https://api.pollsapi.com/v1"
}

#' @keywords internal
vector_to_options_list <- function(options_vector) {
  options_list <- lapply(options_vector, function(.x) list(text = .x))
  options_list
}

#' @keywords internal
check_api_key <- function(api_key) {
  if(api_key %in% c("", NA)) stop("API key missing. Please pass it explicitly to api_key argument
  or add your api key as environment variable named POLLSAPI_KEY.
  Example:
  Sys.setenv(POLLSAPI_KEY = 'AA6QP71AS0413AN1BFGAE24Q52AE')")
}

#' @keywords internal
make_api_get <- function(
  endpoint,
  api_key
) {
  url <- file.path(base_url(), endpoint)
  check_api_key(api_key)

  response <- httr::GET(
    url = url,
    config = httr::add_headers(
      "Content-Type" = "application/json",
      "api-key" = api_key
    )
  )
  class(response) <- c("pollsapi", class(response))
  response
}

#' @keywords internal
make_api_post <- function(
  endpoint,
  api_key,
  body
) {
  url <- file.path(base_url(), endpoint)
  check_api_key(api_key)

  response <- httr::POST(
    url = url,
    config = httr::add_headers(
      "Content-Type" = "application/json",
      "api-key" = api_key
    ),
    body = body,
    encode = "json"
  )
  class(response) <- c("pollsapi", class(response))
  response
}

#' @export
print.pollsapi <- function(obj) {
  str(httr::content(obj))
}

#' @export
polls_create_poll <- function(
  question,
  options,
  api_key = Sys.getenv("POLLSAPI_KEY"),
  identifier = NULL,
  data = NULL
  ) {

  body <- list(
    question = question,
    options = vector_to_options_list(options),
    identifier = identifier,
    data = data
  )

  make_api_post(
    endpoint = "create/poll",
    api_key = api_key,
    body = body
  )
}

#' @export
pollsapi_get_poll_by_id <- function(
  poll_id,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/poll/{poll_id}"),
    api_key = api_key
  )
}

#' @export
pollsapi_get_all_polls <- function(
  offset = 0,
  limit = 100,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/polls?offset={offset}&limit={limit}"),
    api_key = api_key
  )
}

#' @export
pollsapi_get_polls_by_identifier <- function(
  identifier,
  offset = 0,
  limit = 100,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/polls-with-identifier/{identifier}?offset={offset}&limit={limit}"),
    api_key = api_key
  )
}

#' @export
pollsapi_create_vote <- function(
  poll_id,
  option_id,
  identifier,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  body <- list(
    poll_id = poll_id,
    option_id = option_id,
    identifier = identifier
  )

  make_api_post(
    endpoint = "create/vote",
    api_key = api_key,
    body = body
  )
}

#' @export
pollsapi_get_vote_by_id <- function(
  vote_id,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/vote/{vote_id}"),
    api_key = api_key
  )
}

#' @export
pollsapi_get_all_votes_on_a_poll <- function(
  poll_id,
  offset = 0,
  limit = 100,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/votes/{poll_id}?offset={offset}&limit={limit}"),
    api_key = api_key
  )
}

#' @export
pollsapi_get_all_votes_with_identifier <- function(
  identifier,
  offset = 0,
  limit = 100,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  make_api_get(
    endpoint = glue::glue("get/votes-with-identifier/{identifier}?offset={offset}&limit={limit}"),
    api_key = api_key
  )
}

#' @export
pollsapi_remove_vote <- function(
  vote_id,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  body <- list(
    vote_id = vote_id
  )

  make_api_post(
    endpoint = "remove/vote",
    api_key = api_key,
    body = body
  )
}

#' @export
pollsapi_remove_poll <- function(
  poll_id,
  api_key = Sys.getenv("POLLSAPI_KEY")
) {
  body <- list(
    poll_id = poll_id
  )

  make_api_post(
    endpoint = "remove/poll",
    api_key = api_key,
    body = body
  )
}


