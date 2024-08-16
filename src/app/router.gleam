import app/pages
import app/pages/shared/layout
import app/web.{type Context}
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, context: Context) -> Response {
  use request <- web.middleware(request, context)

  case wisp.path_segments(request) {
    [] ->
      [pages.home()]
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    ["bad-request"] -> wisp.bad_request()
    ["internal-server-error"] -> wisp.internal_server_error()
    _ -> wisp.not_found()
  }
}
