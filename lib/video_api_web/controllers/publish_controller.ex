defmodule VideoApiWeb.PublishController do
  use VideoApiWeb, :controller

  alias VideoApi.Publish

  @spec new(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def new(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
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
end
