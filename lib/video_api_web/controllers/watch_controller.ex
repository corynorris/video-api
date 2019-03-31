defmodule VideoApiWeb.WatchController do
  use VideoApiWeb, :controller
  alias VideoApi.Videos

  import VideoApi.Utils

  def show(%{req_headers: headers} = conn, %{"id" => id}) do
    video = Videos.get_video!(id)
    send_video(conn, headers, video)
  end

  def send_video(conn, headers, video) do
    video_path = build_video_path(video)
    offset = get_offset(headers)
    file_size = get_file_size(video_path)

    conn
    |> Plug.Conn.put_resp_header("content-type", video.content_type)
    |> Plug.Conn.put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
    |> Plug.Conn.send_file(206, video_path, offset, file_size - offset)
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
