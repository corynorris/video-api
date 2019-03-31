defmodule VideoApi.Repo.Migrations.UpdateVideosTable do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :status, :smallint
    end

    create index(:videos, [:user_id])
  end
end
