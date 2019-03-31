defmodule VideoApiWeb.DashboardController do
  use VideoApiWeb, :controller

  alias VideoApi.Videos
  alias VideoApi.Transcodings

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    stats = Videos.video_stats(user)
    events = Transcodings.list_transcodings(user, params)

    render(conn, "index.html", video_stats: stats, events: events)
  end
end
