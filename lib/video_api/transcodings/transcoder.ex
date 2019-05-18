defmodule VideoApi.Transcoder do
  @behaviour Honeydew.Worker

  alias VideoApi.Videos
  alias VideoApi.Transcodings
  alias Porcelain.Result
  alias VideoApi.Utils

  def transcode(video) do
    Transcodings.log("Starting transcode for #{video.label}", video, :info)

    source_path = Utils.build_video_path(video)
    output_path = Utils.build_transcode_path(video.path)
    output_path |> Path.dirname() |> File.mkdir_p()

    "bash #{File.cwd!()}/priv/scripts/create-vod-hls.sh #{source_path} #{output_path}"
    |> Porcelain.shell()
    |> case do
      %Result{out: _output, status: 0} ->
        Transcodings.log("Succesfully transcoded #{video.label}", video, :success)
        Videos.update_video_status(video, :complete)
        {:ok, "success"}

      %Result{out: output, status: 1} ->
        Transcodings.log(output, video, "error")
        Transcodings.log("Failed to transcoded #{video.label}", video, :error)
        Videos.update_video_status(video, :failed)

      error ->
        Transcodings.log("An unknown error has occured", video, "error")
        Transcodings.log("Failed to transcoded #{video.label}", video, :error)
        Videos.update_video_status(video, :failed)
        {:error, error}
    end
  end
end
