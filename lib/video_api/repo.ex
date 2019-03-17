defmodule VideoApi.Repo do
  use Ecto.Repo,
    otp_app: :video_api,
    adapter: Ecto.Adapters.Postgres
end
