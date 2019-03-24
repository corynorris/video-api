defmodule VideoApiWeb.ApiKeyController do
  use VideoApiWeb, :controller

  alias VideoApi.ApiKeys
  alias VideoApi.ApiKeys.ApiKey

  def index(conn, _params) do
    api_keys = ApiKeys.list_api_keys()
    render(conn, "index.html", api_keys: api_keys)
  end

  def new(conn, _params) do
    changeset = ApiKeys.change_api_key(%ApiKey{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"api_key" => api_key_params}) do
    case ApiKeys.create_api_key(api_key_params) do
      {:ok, api_key} ->
        conn
        |> put_flash(:info, "Api key created successfully.")
        |> redirect(to: Routes.api_key_path(conn, :show, api_key))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    api_key = ApiKeys.get_api_key!(id)
    render(conn, "show.html", api_key: api_key)
  end

  def edit(conn, %{"id" => id}) do
    api_key = ApiKeys.get_api_key!(id)
    changeset = ApiKeys.change_api_key(api_key)
    render(conn, "edit.html", api_key: api_key, changeset: changeset)
  end

  def update(conn, %{"id" => id, "api_key" => api_key_params}) do
    api_key = ApiKeys.get_api_key!(id)

    case ApiKeys.update_api_key(api_key, api_key_params) do
      {:ok, api_key} ->
        conn
        |> put_flash(:info, "Api key updated successfully.")
        |> redirect(to: Routes.api_key_path(conn, :show, api_key))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", api_key: api_key, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    api_key = ApiKeys.get_api_key!(id)
    {:ok, _api_key} = ApiKeys.delete_api_key(api_key)

    conn
    |> put_flash(:info, "Api key deleted successfully.")
    |> redirect(to: Routes.api_key_path(conn, :index))
  end
end
