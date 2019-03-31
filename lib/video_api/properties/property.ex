defmodule VideoApi.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :title, :string
    field :description, :string
    field :url, :string

    belongs_to(:user, VideoApi.Accounts.User)
    has_many(:auth_tokens, VideoApi.AuthTokens.AuthToken)

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:title, :url, :description])
    |> validate_required([:title, :url, :description])
  end
end
