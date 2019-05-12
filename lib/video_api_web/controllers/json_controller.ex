defmodule VideoApiWeb.JsonController do
  use VideoApiWeb, :controller

  alias VideoApi.Json

  def list_videos(conn, %{"api_key" => api_key}) do
    videos = Json.list_videos(api_key)

    case videos do
      nil ->
        put_status(conn, :not_found) |> json(%{})

      _ ->
        render(conn, "videos.json", videos: videos)
    end
  end

  def get_video(conn, %{"api_key" => api_key, "video_id" => video_id}) do
    video = Json.get_video(api_key, video_id)

    case video do
      nil ->
        put_status(conn, :not_found) |> json(%{})

      _ ->
        render(conn, "video.json", video: video)
    end
  end

  def get_property(conn, %{"api_key" => api_key}) do
    property = Json.get_property(api_key)

    case property do
      nil ->
        put_status(conn, :not_found) |> json(%{})

      _ ->
        render(conn, "property.json", property: property)
    end
  end
end
