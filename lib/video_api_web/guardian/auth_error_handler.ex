defmodule VideoApiWeb.Guardian.AuthErrorHandler do
  alias VideoApiWeb.Router.Helpers, as: Routes
  import Phoenix.Controller, only: [redirect: 2]

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, _, _) do
    redirect(conn, to: Routes.session_path(conn, :new))
  end
end
