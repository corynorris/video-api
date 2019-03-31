defmodule VideoApi.AuthTokens.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "auth_tokens" do
    field :token, :string
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    belongs_to(:property, VideoApi.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> unique_constraint(:token)
    |> foreign_key_constraint(:property_id)
  end

  def revoke_changeset(auth_token) do
    auth_token
    |> change()
    |> put_change(:revoked, true)
    |> put_change(:revoked_at, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
