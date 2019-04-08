defmodule VideoApi.Properties.Property do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(label)a
  @optional_fields ~w(url description)a

  schema "properties" do
    field :label, :string
    field :description, :string
    field :url, :string

    belongs_to(:user, VideoApi.Accounts.User)
    has_many(:auth_tokens, VideoApi.AuthTokens.AuthToken)

    many_to_many(
      :videos,
      VideoApi.Videos.Video,
      join_through: "published",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:label, name: :unique_property_label)
    |> validate_url(:url)
  end

  def changeset_update_videos(property, videos) do
    property
    |> cast(%{}, @required_fields ++ @optional_fields)
    |> put_assoc(:videos, videos)
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect(msg)}"}]
      end
    end)
  end
end
