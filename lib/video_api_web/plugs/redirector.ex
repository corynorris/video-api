defmodule VideoApiWeb.Plugs.Redirector do
  @moduledoc "Redirects logged in users to X page."

  alias VideoApiWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [redirect: 2]
  import VideoApiWeb.Guardian.Plug, only: [authenticated?: 1, current_resource: 1, sign_out: 1]

  def init(opts) do
    opts
  end

  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _opts) do
    cond do
      authenticated?(conn) and current_resource(conn) != nil ->
        redirect(conn, to: Routes.session_path(conn, :new))

      authenticated?(conn) ->
        sign_out(conn) |> redirect(to: Routes.dashboard_path(conn, :index))

      true ->
        conn
    end
  end
end
