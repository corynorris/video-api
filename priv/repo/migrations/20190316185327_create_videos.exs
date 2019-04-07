defmodule VideoApi.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :label, :string
      add :description, :string
      add :filename, :string
      add :content_type, :string
      add :path, :string
      timestamps()
    end

    create(unique_index(:videos, [:path]))
  end
end
