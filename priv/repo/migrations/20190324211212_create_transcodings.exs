defmodule VideoApi.Repo.Migrations.CreateTranscodings do
  use Ecto.Migration

  def change do
    create table(:transcodings) do
      add :video_1080p, :string
      add :video_720p, :string
      add :video_420p, :string
      add :video_360p, :string
      add :video_id, references(:videos, on_delete: :delete_all)
      timestamps()
    end

    create index(:transcodings, [:video_id])
  end
end
