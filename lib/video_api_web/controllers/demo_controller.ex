defmodule VideoApiWeb.DemoController do
  use VideoApiWeb, :controller

  alias VideoApi.Videos

  def show(conn, _params) do
    video = Videos.get_demo()
    render(conn, "show.html", video: video)
  end
end
