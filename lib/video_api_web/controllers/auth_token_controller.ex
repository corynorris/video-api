defmodule VideoApiWeb.AuthTokenController do
  use VideoApiWeb, :controller

  alias VideoApi.AuthTokens
  alias VideoApi.Properties

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    auth_tokens = AuthTokens.list_auth_tokens(user, params)
    render(conn, "index.html", auth_tokens: auth_tokens)
  end

  def new(conn, %{"property" => id}) do
    user = Guardian.Plug.current_resource(conn)
    property = Properties.get_property(user, id)

    case AuthTokens.create_auth_token(property) do
      {:ok, _auth_token} ->
        conn
        |> put_flash(:info, "Api key created successfully.")
        |> redirect(to: Routes.property_path(conn, :show, id))

      {:error, _error} ->
        conn
        |> put_flash(:info, "Error generating API key, please try again.")
        |> redirect(to: Routes.property_path(conn, :show, id))
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    auth_token = AuthTokens.get_auth_token(user, id)

    AuthTokens.revoke_auth_token(auth_token)

    conn
    |> redirect(to: Routes.property_path(conn, :show, auth_token.property_id))
  end
end
