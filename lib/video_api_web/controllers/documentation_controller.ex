defmodule VideoApiWeb.DocumentationController do
  use VideoApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
