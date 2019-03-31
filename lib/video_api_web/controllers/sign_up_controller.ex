defmodule VideoApiWeb.SignUpController do
  use VideoApiWeb, :controller

  alias VideoApiWeb.Guardian
  alias VideoApi.Accounts
  alias VideoApi.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "sign_up.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end
  end
end
