defmodule VideoApi.Repo.Migrations.CreatePublishedTable do
  use Ecto.Migration

  def change do
    create table(:published, primary_key: false) do
      add :video_id, references(:videos, on_delete: :delete_all, primary_key: true)
      add :property_id, references(:properties, on_delete: :delete_all, primary_key: true)
    end

    create index(:published, [:video_id])
    create index(:published, [:property_id])
    create(unique_index(:published, [:video_id, :property_id], name: :unique_publication))
  end
end
