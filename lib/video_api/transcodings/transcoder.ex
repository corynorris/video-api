defmodule VideoApi.Transcoder do
  @behaviour Honeydew.Worker

  alias VideoApi.Transcodings
  alias Porcelain.Result
  alias VideoApi.Utils

  def transcode(video) do
    IO.inspect(video)

    source_path = Utils.build_video_path(video)
    IO.inspect(source_path)

    output_path = Utils.build_transcode_path(video)
    output_path |> Path.dirname() |> File.mkdir_p()
    IO.inspect(output_path)

    "bash #{File.cwd!()}/priv/scripts/create-vod-hls.sh #{source_path} #{output_path}"
    |> Porcelain.shell()
    |> case do
      %Result{out: _output, status: 0} ->
        Transcodings.create_transcoding(%{
          video_1080p: "1080p.m3u8",
          video_720p: "720p.m3u8",
          video_360p: "360p.m3u8",
          video_420p: "420p.m3u8",
          video_id: video.id
        })

      other ->
        {:error, other}
    end
  end
end
