defmodule VideoApi.Transcoder do
  alias Porcelain.Result

  def transcode(source_path, output_path) do
    output_path |> Path.dirname() |> File.mkdir_p()

    "bash #{File.cwd!()}/priv/scripts/create-vod-hls.sh #{source_path} #{output_path}"
    |> Porcelain.shell()
    |> case do
      %Result{out: output, status: 0} -> {:ok, output}
      other -> {:error, other}
    end
  end
end
