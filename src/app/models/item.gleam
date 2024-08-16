import wisp

pub type ItemStatus {
  Completed
  Uncompleted
}

pub type Item {
  Item(id: String, title: String, status: ItemStatus)
}

pub fn create_item(title: String) -> Item {
  Item(id: wisp.random_string(64), title:, status: Uncompleted)
}

pub fn parse_item(id: String, title: String, completed: Bool) -> Item {
  Item(id:, title:, status: case completed {
    True -> Completed
    False -> Uncompleted
  })
}

pub fn toggle_todo(item: Item) -> Item {
  let new_status = case item.status {
    Completed -> Uncompleted
    Uncompleted -> Completed
  }

  Item(..item, status: new_status)
}

pub fn item_status_to_bool(status: ItemStatus) -> Bool {
  case status {
    Completed -> True
    Uncompleted -> False
  }
}
