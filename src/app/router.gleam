import app/pages
import app/pages/shared/layout
import app/routes/item_routes
import app/web.{type Context}
import gleam/http
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(request: Request, context: Context) -> Response {
  use request <- web.middleware(request, context)
  use context <- item_routes.items_middleware(request, context)

  case wisp.path_segments(request) {
    ["items"] ->
      [pages.home(context.items)]
      |> layout.layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    ["todos"] -> {
      use <- wisp.require_method(request, http.Post)
      item_routes.create_item(request, context)
    }
    ["todos", id] -> {
      use <- wisp.require_method(request, http.Delete)
      item_routes.delete_item(request, context, id)
    }
    ["todos", id, "complete"] -> {
      use <- wisp.require_method(request, http.Patch)
      item_routes.toggle_item(request, context, id)
    }
    ["bad-request"] -> wisp.bad_request()
    ["internal-server-error"] -> wisp.internal_server_error()
    _ -> wisp.not_found()
  }
}
