import app/web.{type Context}
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(_req: Request, _ctx: Context) -> Response {
  wisp.html_response(string_builder.from_string("<h1>Hello, World!</h1>"), 200)
}
