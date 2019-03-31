defmodule VideoApiWeb.TranscodingController do
  use VideoApiWeb, :controller

  alias VideoApi.Transcodings

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    transcodings = Transcodings.list_transcodings(user, params)
    render(conn, "index.html", transcodings: transcodings)
  end
end
