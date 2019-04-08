defmodule VideoApiWeb.DashboardController do
  use VideoApiWeb, :controller

  alias VideoApi.Videos
  alias VideoApi.Publish
  alias VideoApi.Properties
  alias VideoApi.Transcodings

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    video_stats = Videos.video_stats(user)
    published = Publish.publish_stats(user)
    property_stats = Properties.property_stats(user)
    events = Transcodings.list_transcodings(user, params)

    render(conn, "index.html",
      video_stats: video_stats,
      property_stats: property_stats,
      events: events,
      published: published
    )
  end
end
