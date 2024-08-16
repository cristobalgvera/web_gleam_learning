import app/models/item.{type Item, Completed, Uncompleted}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn add_item() -> Element(a) {
  html.form([attribute.method("POST"), attribute.action("/todos")], [
    html.label([], [
      html.text("What needs to be done?"),
      html.br([]),
      html.input([attribute.name("todo_title"), attribute.autofocus(True)]),
    ]),
  ])
}

pub fn list_items(items: List(Item)) -> Element(a) {
  html.div([], case items {
    [] -> [html.div([], [element.text("No todos yet!")])]
    _ -> list.map(items, item)
  })
}

fn item(item: Item) -> Element(a) {
  html.div([], [
    html.div([], [
      html.div([], [
        html.span(
          [
            attribute.class(case item.status {
              Completed -> "completed"
              Uncompleted -> ""
            }),
          ],
          [element.text(item.title)],
        ),
        html.form(
          [
            attribute.method("POST"),
            attribute.action("/todos/" <> item.id <> "/complete?_method=PATCH"),
          ],
          [
            html.button([], [
              element.text(case item.status {
                Completed -> "🔲"
                Uncompleted -> "✅"
              }),
            ]),
          ],
        ),
      ]),
    ]),
    html.form(
      [
        attribute.method("POST"),
        attribute.action("/todos/" <> item.id <> "?_method=DELETE"),
      ],
      [html.button([], [element.text("❌")])],
    ),
  ])
}
