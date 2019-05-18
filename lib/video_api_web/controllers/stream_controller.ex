defmodule VideoApiWeb.StreamController do
  use VideoApiWeb, :controller

  import VideoApi.Utils

  @allowed_extensions ~w(m3u8 ts)
  @allowed_files ~r/(1080p|360p|720p|480p)(_[0-9]+)*/

  def show(conn, %{"guid" => guid, "filename" => filename}) do
    [quality, ext] = String.split(filename, ".")

    with true <- Regex.match?(@allowed_files, quality),
         true <- Enum.member?(@allowed_extensions, ext) do
      send_video(conn, guid, filename)
    else
      _ -> send_resp(conn, 403, "Not allowed")
    end
  end

  def send_video(conn, guid, filename) do
    video_path = build_transcode_path(guid) |> Path.join(filename)
    size = get_file_size(video_path)

    conn
    |> Plug.Conn.put_resp_header("content-type", "video/mp2t")
    |> put_resp_header("Accept-Ranges", "bytes")
    |> put_resp_header("Content-Length", "#{size}")
    |> Plug.Conn.send_file(200, video_path)
  end

  def get_file_size(path) do
    {:ok, %{size: size}} = File.stat(path)
    size
  end
end
