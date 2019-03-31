defmodule VideoApiWeb.AuthTokenController do
  use VideoApiWeb, :controller

  alias VideoApi.AuthTokens

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    auth_tokens = AuthTokens.list_auth_tokens(user, params)
    render(conn, "index.html", auth_tokens: auth_tokens)
  end

  def new(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    case AuthTokens.create_auth_token(user) do
      {:ok, auth_token} ->
        conn
        |> put_flash(:info, "Api key created successfully.")
        |> redirect(to: Routes.auth_token_path(conn, :index))

      {:error, _error} ->
        conn
        |> put_flash(:info, "Error generating API key, please try again.")
        |> redirect(to: Routes.auth_token_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> Guardian.Plug.current_resource()
    |> AuthTokens.revoke_auth_token(id)

    conn
    |> redirect(to: Routes.auth_token_path(conn, :index))
  end
end
