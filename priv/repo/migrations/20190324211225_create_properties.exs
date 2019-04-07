defmodule VideoApi.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :label, :string
      add :url, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end

    create index(:properties, [:user_id])
    create(unique_index(:properties, [:label, :user_id], name: :unique_property_label))
  end
end
