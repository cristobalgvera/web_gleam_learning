import dot_env
import dot_env/env
import gleam/erlang/process
import mist
import wisp

pub fn main() {
  dot_env.load_default()
  wisp.configure_logger()

  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")

  let assert Ok(_) =
    wisp.mist_handler(fn(_) { todo }, secret_key_base)
    |> mist.new
    |> mist.start_http

  process.sleep_forever()
}
