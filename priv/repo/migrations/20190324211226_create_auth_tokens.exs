defmodule VideoApi.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :token, :text, null: false
      add :revoked, :boolean, default: false, null: false
      add :revoked_at, :utc_datetime
      add :property_id, references(:properties, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:auth_tokens, [:token])
    create index(:auth_tokens, [:property_id])
  end
end
