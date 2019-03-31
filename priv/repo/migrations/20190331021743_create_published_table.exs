defmodule VideoApi.Repo.Migrations.CreatePublishedTable do
  use Ecto.Migration

  def change do
    create table(:published) do
      add :video_id, references(:videos, on_delete: :delete_all)
      add :property_id, references(:properties, on_delete: :delete_all)
    end

    create index(:published, [:video_id])
    create index(:published, [:property_id])
  end
end
