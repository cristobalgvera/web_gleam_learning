import app/web.{type Context}
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, context: Context) -> Response {
  use request <- web.middleware(request, context)

  case wisp.path_segments(request) {
    [] -> wisp.html_response(string_builder.from_string("<h1>Home</h1>"), 200)
    ["bad-request"] -> wisp.bad_request()
    ["internal-server-error"] -> wisp.internal_server_error()
    _ -> wisp.not_found()
  }
}
