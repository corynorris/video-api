defmodule VideoApiWeb.Plugs.Redirector do
  @moduledoc "Redirects logged in users to X page."

  alias VideoApiWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [redirect: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if Guardian.Plug.authenticated?(conn, []) do
      IO.puts("authenticated, redirecting to video")
      redirect(conn, to: Routes.video_path(conn, :index))
    else
      IO.puts("not authenticated")

      conn
    end
  end
end
