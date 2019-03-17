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

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Guardian.AuthPipeline
  end

  scope "/", VideoApiWeb do
    pipe_through [:browser]

    get "/", PageController, :index

    resources "/users", UserController, [:create, :show]
  end

  scope "/" do
    pipe_through [:auth]
    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideoApiWeb do
  #   pipe_through :api
  # end
end
