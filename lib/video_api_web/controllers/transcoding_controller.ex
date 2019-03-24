defmodule VideoApiWeb.TranscodingController do
  use VideoApiWeb, :controller

  alias VideoApi.Transcodings
  alias VideoApi.Transcodings.Transcoding

  def index(conn, _params) do
    transcodings = Transcodings.list_transcodings()
    render(conn, "index.html", transcodings: transcodings)
  end

  def show(conn, %{"id" => id}) do
    transcoding = Transcodings.get_transcoding!(id)
    render(conn, "show.html", transcoding: transcoding)
  end
end
