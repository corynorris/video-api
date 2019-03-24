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

  pipeline :redirect_if_authed do
    plug Guardian.LoadSessionPipeline
    plug VideoApiWeb.Plugs.Redirector
  end

  pipeline :enforce_auth do
    plug Guardian.EnforceAuthPipeline
    plug VideoApiWeb.Plugs.CurrentUser
    plug :put_layout, {VideoApiWeb.LayoutView, :user}
  end

  scope "/", VideoApiWeb do
    pipe_through [:browser, :redirect_if_authed]

    get "/", PageController, :index

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create

    get "/sign_up", SignUpController, :new
    post "/sign_up", SignUpController, :create
  end

  scope "/", VideoApiWeb do
    pipe_through [:browser, :enforce_auth]

    get "/sign_out", SessionController, :delete

    get "/dashboard", DashboardController, :index
    get "/documentation", DocumentationController, :index

    resources "/videos", VideoController
    resources "/transcodings", TranscodingController, only: [:index, :show]

    resources "/user/api", ApiKeyController
    get "/user/profile", UserController, :show

    get "/user/profile/edit", UserController, :edit
    put "/user/profile/edit", UserController, :update
  end
end
