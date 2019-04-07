defmodule VideoApi.Repo.Migrations.UpdateVideosTable do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :status, :smallint
    end

    create index(:videos, [:user_id])
    create(unique_index(:videos, [:label, :user_id], name: :unique_video_label))
  end
end
