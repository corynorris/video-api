defmodule VideoApiWeb.PropertyController do
  use VideoApiWeb, :controller

  alias VideoApi.AuthTokens
  alias VideoApi.Properties
  alias VideoApi.Properties.Property

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    properties = Properties.list_properties(user, params)
    render(conn, "index.html", properties: properties)
  end

  def new(conn, _params) do
    changeset = Properties.change_property(%Property{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"property" => property_params}) do
    user = Guardian.Plug.current_resource(conn)

    case Properties.create_property(user, property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property created successfully.")
        |> redirect(to: Routes.property_path(conn, :show, property))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, params = %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    property = Properties.get_property(user, id)
    auth_tokens = AuthTokens.list_auth_tokens(property, params)
    render(conn, "show.html", property: property, auth_tokens: auth_tokens)
  end

  def edit(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    property = Properties.get_property(user, id)
    changeset = Properties.change_property(property)
    render(conn, "edit.html", property: property, changeset: changeset)
  end

  def update(conn, %{"id" => id, "property" => property_params}) do
    user = Guardian.Plug.current_resource(conn)
    property = Properties.get_property(user, id)

    case Properties.update_property(property, property_params) do
      {:ok, property} ->
        conn
        |> put_flash(:info, "Property updated successfully.")
        |> redirect(to: Routes.property_path(conn, :show, property))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", property: property, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    property = Properties.get_property(user, id)
    {:ok, _property} = Properties.delete_property(property)

    conn
    |> put_flash(:info, "Property deleted successfully.")
    |> redirect(to: Routes.property_path(conn, :index))
  end
end
