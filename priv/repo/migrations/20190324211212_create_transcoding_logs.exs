defmodule VideoApi.Repo.Migrations.CreateTranscodings do
  use Ecto.Migration

  def change do
    create table(:transcoding_logs) do
      add :level, :smallint
      add :message, :text
      add :video_id, references(:videos, on_delete: :delete_all)
      timestamps()
    end

    create index(:transcoding_logs, [:video_id])
  end
end
