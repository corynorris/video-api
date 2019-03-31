defmodule VideoApi.Repo.Migrations.CreatePublishedTable do
  use Ecto.Migration

  def change do
    create table(:published) do
      add :published_at, :utc_datetime
      add :message, :text
      add :video_id, references(:videos, on_delete: :delete_all)
      
  end

  create index(:published, [:video_id])

end
