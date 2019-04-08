defmodule VideoApiWeb.PublishController do
  use VideoApiWeb, :controller

  alias VideoApi.Publish
  alias VideoApi.Properties

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"property" => property_id, "videos" => video_ids}) do
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
        user = Guardian.Plug.current_resource(conn)
        property = Properties.get_property(user, property_id)
        IO.inspect(property)
        video_ids = String.split(video_ids, ",")

        Publish.publish_videos_to_property(user, property, video_ids)
        redirect(conn, to: Routes.property_path(conn, :show, property_id))
    end
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
