defmodule VideoApiWeb.JsonController do
  use VideoApiWeb, :controller

  alias VideoApi.Videos
  alias VideoApi.Properties

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    videos = Videos.list_videos(user)
    properties = Properties.list_properties(user)
    render(conn, "index.json", %{videos: videos, properties: properties})
  end
end
