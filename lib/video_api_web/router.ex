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
    plug CORSPlug
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :stream do
    plug CORSPlug
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

    get "/watch/:id", WatchController, :show
    get("/videos/json", VideoController, :json)
    resources "/videos", VideoController
    resources "/transcodings", TranscodingController, only: [:index, :show]
    resources "/properties", PropertyController

    get("/publish", PublishController, :new)
    post("/publish", PublishController, :create)

    post "/user/auth/generate", AuthTokenController, :new
    delete "/user/auth/:id", AuthTokenController, :delete

    get "/user/profile", UserController, :show
    get "/user/profile/edit", UserController, :edit
    put "/user/profile/edit", UserController, :update
  end

  scope "/api", VideoApiWeb do
    pipe_through [:api]
    get "/videos", JsonController, :list_videos
    get "/videos/:video_id", JsonController, :get_video
    get "/property", JsonController, :get_property
  end

  scope "/stream", VideoApiWeb do
    pipe_through [:stream]
    get("/:guid/:filename", StreamController, :show)
  end
end
