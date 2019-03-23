defmodule VideoApiWeb.Guardian.LoadSessionPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :video_api,
    module: VideoApiWeb.Guardian,
    error_handler: VideoApiWeb.Guardian.AuthErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true

  IO.puts("Loaded session")
end
