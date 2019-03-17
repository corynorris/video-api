defmodule VideoApi.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :content_type, :string
    field :description, :string
    field :filename, :string
    field :path, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:title, :description, :filename, :content_type, :path])
    |> validate_required([:title, :description, :filename, :content_type, :path])
  end
end
