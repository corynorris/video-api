defmodule VideoApi.Repo.Migrations.CreateApiKeys do
  use Ecto.Migration

  def change do
    create table(:api_keys) do
      add :api_key, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :video_id, references(:videos, on_delete: :nothing)
      timestamps()
    end

    create unique_index(:api_keys, [:api_key])
    create index(:api_keys, [:user_id])
    create index(:api_keys, [:video_id])
  end
end
