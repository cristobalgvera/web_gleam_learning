import app/router
import app/web
import dot_env
import dot_env/env
import gleam/erlang/process
import mist
import wisp

pub fn main() {
  dot_env.load_default()
  wisp.configure_logger()

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")

  let context = web.Context(static_directory: get_static_directory(), items: [])

  let assert Ok(_) =
    wisp.mist_handler(router.handle_request(_, context), secret_key_base)
    |> mist.new
    |> mist.start_http

  process.sleep_forever()
}

fn get_static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("web_gleam_learning")

  priv_directory <> "/static"
}
