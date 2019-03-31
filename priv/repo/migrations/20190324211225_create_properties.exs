defmodule VideoApi.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :title, :string
      add :url, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:properties, [:user_id])
    create(unique_index(:properties, [:title]))
  end
end
