defmodule VideoApiWeb.UserController do
  use VideoApiWeb, :controller

  alias VideoApi.Accounts

  def show(conn, _parmas) do
    user = Guardian.Plug.current_resource(conn)

    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = Guardian.Plug.current_resource(conn)

    case Accounts.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
