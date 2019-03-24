defmodule VideoApi.Utils do
  def build_video_path(video) do
    Application.get_env(:video_api, :uploads_dir) |> Path.join(video.path)
  end

  def build_transcode_path(video) do
    Application.get_env(:video_api, :transcodes_dir) |> Path.join(video.path)
  end
end
