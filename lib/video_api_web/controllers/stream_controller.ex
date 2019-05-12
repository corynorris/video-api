defmodule VideoApiWeb.StreamController do
  use VideoApiWeb, :controller
  alias VideoApi.Videos

  import VideoApi.Utils

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    video = Videos.get_demo()
    IO.inspect(video)
    send_video(conn, headers, video)
  end

  def send_video(conn, headers, video) do
    video_path =
      video
      |> build_transcode_path()
      |> Kernel.<>("/1080p.m3u8")

    conn
    |> Plug.Conn.put_resp_header("content-type", "application/vnd.apple.mpegurl")
    |> Plug.Conn.send_file(206, video_path)
  end

  def get_offset(headers) do
    case List.keyfind(headers, "range", 0) do
      {"range", "bytes=" <> start_pos} ->
        String.split(start_pos, "-") |> hd |> String.to_integer()

      nil ->
        0
    end
  end

  def get_file_size(path) do
    {:ok, %{size: size}} = File.stat(path)
    size
  end
end
