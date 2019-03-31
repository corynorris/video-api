defmodule VideoApi.Repo do
  use Ecto.Repo,
    otp_app: :video_api,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
