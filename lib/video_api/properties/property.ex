defmodule VideoApi.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :label, :string
    field :description, :string
    field :url, :string

    belongs_to(:user, VideoApi.Accounts.User)
    has_many(:auth_tokens, VideoApi.AuthTokens.AuthToken)

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:label, :url, :description])
    |> validate_required([:label, :url, :description])
    |> unique_constraint(:unique_label, name: :unique_property_label)
  end
end
