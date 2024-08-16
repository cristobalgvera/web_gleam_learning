import app/models/item.{type Item}
import app/pages/items

pub fn home(items_list: List(Item)) {
  items.root(items_list)
}
