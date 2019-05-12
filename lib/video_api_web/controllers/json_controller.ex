defmodule VideoApiWeb.JsonController do
  use VideoApiWeb, :controller

  alias VideoApi.Json

  def index(conn, %{auth_token: auth_token}) do
    Json.list_videos(auth_token)
  end

  def get_video(conn, %{auth_token: auth_token}) do
    Json.list_videos(auth_token)
  end

  def get_property(conn, %{auth_token: auth_token}) do
    Json.list_videos(auth_token)
  end
end
