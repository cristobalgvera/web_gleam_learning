import app/models/item.{type Item}
import app/pages/components/item_actions
import lustre/element.{type Element}
import lustre/element/html

pub fn root(items: List(Item)) -> Element(t) {
  html.main([], [
    html.h1([], [html.text("Todo App")]),
    html.hr([]),
    item_actions.add_item(),
    html.hr([]),
    item_actions.list_items(items),
  ])
}
