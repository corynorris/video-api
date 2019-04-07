defmodule VideoApiWeb.PublishController do
  use VideoApiWeb, :controller

  alias VideoApi.Publish

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"property" => property_id, "videos" => video_ids}) do
    user = Guardian.Plug.current_resource(conn)

    case {property_id, video_ids} do
      {"", _video_ids} ->
        conn
        |> put_flash(:error, "Invalid property selection")
        |> render("new.html")

      {_property_ids, ""} ->
        conn
        |> put_flash(:error, "Invalid video selection")
        |> render("new.html")

      _other ->
        redirect(conn, to: Routes.property_path(conn, :show, property_id))
    end

    # case Properties.create_property(user, property_params) do
    #   {:ok, property} ->
    #     conn
    #     |> put_flash(:info, "Publish created successfully.")
    #     |> redirect(to: Routes.property_path(conn, :show, property))

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
  end

  def create(conn, _params) do
    conn
    |> put_flash(
      :error,
      "Invalid selection, please make sure you have created a property and video"
    )
    |> render("new.html")
  end
end
