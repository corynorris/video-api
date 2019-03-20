defmodule VideoApiWeb.Router do
  use VideoApiWeb, :router

  alias VideoApiWeb.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/", VideoApiWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    get "sign_up", UserController, :new
    # resources "/users", UserController, [:create, :show]
    resources "/videos", VideoController
  end
end
