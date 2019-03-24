defmodule VideoApiWeb.SessionController do
  use VideoApiWeb, :controller

  alias VideoApiWeb.Guardian
  alias VideoApi.Accounts
  alias VideoApi.Accounts.User
  alias VideoApi.Accounts.Auth

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "sign_in.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Auth.sign_in(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> assign(:current_user, user)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: Routes.video_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        changeset = Map.put(changeset, :action, :insert)
        render(conn, "sign_in.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
