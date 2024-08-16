import app/models/item.{type Item}
import app/web.{type Context, Context}
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/result
import gleam/string
import wisp.{type Request, type Response}

type ItemJson {
  ItemJson(id: String, title: String, completed: Bool)
}

pub fn items_middleware(
  request: Request,
  context: Context,
  handle_request: fn(Context) -> Response,
) {
  let parsed_items = {
    case wisp.get_cookie(request, "todos", wisp.PlainText) {
      Ok(json_string) -> {
        let decoder =
          dynamic.decode3(
            ItemJson,
            dynamic.field("id", dynamic.string),
            dynamic.field("title", dynamic.string),
            dynamic.field("completed", dynamic.bool),
          )
          |> dynamic.list

        case json.decode(json_string, decoder) {
          Ok(items) -> items
          Error(_) -> []
        }
      }
      Error(_) -> []
    }
  }

  let context = Context(..context, items: create_items_from_json(parsed_items))

  handle_request(context)
}

fn create_items_from_json(items: List(ItemJson)) -> List(Item) {
  items
  |> list.map(fn(item) { item.parse_item(item.id, item.title, item.completed) })
}

pub fn create_item(request: Request, context: Context) {
  use form <- wisp.require_form(request)

  let result = {
    use title <- result.try(list.key_find(form.values, "todo_title"))

    list.append(context.items, [item.create_item(title)])
    |> todos_to_json
    |> Ok
  }

  case result {
    Ok(items) ->
      wisp.redirect("/items")
      |> wisp.set_cookie(request, "todos", items, wisp.PlainText, 60 * 60 * 24)
    Error(_) -> wisp.bad_request()
  }
}

pub fn delete_item(request: Request, context: Context, item_id: String) {
  let items =
    list.filter(context.items, fn(item) { item.id != item_id })
    |> todos_to_json

  wisp.redirect("/items")
  |> wisp.set_cookie(request, "todos", items, wisp.PlainText, 60 * 60 * 24)
}

pub fn toggle_item(request: Request, context: Context, item_id: String) {
  let result = {
    use _ <- result.try(
      list.find(context.items, fn(item) { item.id == item_id }),
    )

    list.map(context.items, fn(item) {
      case item.id {
        id if id == item_id -> item.toggle_todo(item)
        _ -> item
      }
    })
    |> todos_to_json
    |> Ok
  }

  case result {
    Ok(items) ->
      wisp.redirect("/items")
      |> wisp.set_cookie(request, "todos", items, wisp.PlainText, 60 * 60 * 24)
    Error(_) -> wisp.bad_request()
  }
}

fn todos_to_json(items: List(Item)) -> String {
  "["
  <> items
  |> list.map(item_to_json)
  |> string.join(",")
  <> "]"
}

fn item_to_json(item: Item) -> String {
  json.object([
    #("id", json.string(item.id)),
    #("title", json.string(item.title)),
    #("completed", json.bool(item.item_status_to_bool(item.status))),
  ])
  |> json.to_string
}
