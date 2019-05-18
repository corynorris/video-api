defmodule VideoApi.Utils do
  def build_video_path(video) do
    Application.get_env(:video_api, :uploads_dir) |> Path.join(video.path)
  end

  def build_video_url(video) do
    guid = Path.basename(video.path, ".mp4")

    VideoApiWeb.Endpoint.url()
    |> Path.join("stream")
    |> Path.join(guid)
    |> Path.join("1080p.m3u8")
  end

  def build_transcode_path(path) do
    guid = Path.basename(path, ".mp4")
    Application.get_env(:video_api, :transcodes_dir) |> Path.join(guid)
  end
end
