defmodule VideoApiWeb.Guardian.AuthErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    to_string(type)
    |> IO.inspect()

    body = Jason.encode!(%{message: to_string(type)})
    IO.inspect(body)
    send_resp(conn, 200, body)
  end
end
