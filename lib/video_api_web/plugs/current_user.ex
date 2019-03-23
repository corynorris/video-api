defmodule VideoApiWeb.Plugs.CurrentUser do
  @moduledoc "Redirects logged in users to X page."

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    conn
    |> assign(:current_user, Guardian.Plug.current_resource(conn))
  end
end
