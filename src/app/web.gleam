import gleam/bool
import gleam/string_builder
import wisp

pub type Context {
  Context(static_directory: String, items: List(String))
}

pub fn middleware(
  request: wisp.Request,
  context: Context,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let request = wisp.method_override(request)
  use <- wisp.serve_static(
    request,
    under: "/static",
    from: context.static_directory,
  )
  use <- wisp.log_request(request)
  use <- wisp.rescue_crashes
  use request <- wisp.handle_head(request)
  use <- default_responses

  handle_request(request)
}

fn default_responses(handle_request: fn() -> wisp.Response) -> wisp.Response {
  let response = handle_request()

  use <- bool.guard(when: response.body != wisp.Empty, return: response)

  case response.status {
    404 | 405 -> create_html_body(response, "<h1>Not Found</h1>")
    400 | 422 -> create_html_body(response, "<h1>Bad request</h1>")
    413 -> create_html_body(response, "<h1>Request entity too large</h1>")
    500 -> create_html_body(response, "<h1>Internal server error</h1>")
    _ -> response
  }
}

fn create_html_body(response: wisp.Response, message: String) -> wisp.Response {
  message
  |> string_builder.from_string
  |> wisp.html_body(response, _)
}
