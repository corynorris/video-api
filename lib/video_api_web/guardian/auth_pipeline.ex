defmodule VideoApiWeb.Guardian.EnforceAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :video_api,
    module: VideoApiWeb.Guardian,
    error_handler: VideoApiWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
