defmodule VideoApiWeb.Plugs.Redirector do
  @moduledoc "Redirects logged in users to X page."

  alias VideoApiWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [redirect: 2]
  import VideoApiWeb.Guardian.Plug, only: [authenticated?: 1]

  def init(opts) do
    opts
  end

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    if authenticated?(conn) do
      redirect(conn, to: Routes.dashboard_path(conn, :index))
    else
      conn
    end
  end
end
