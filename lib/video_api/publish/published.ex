defmodule VideoApi.Publish.Published do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "published" do
    belongs_to(:video, VideoApi.Videos.Video, primary_key: true)
    belongs_to(:property, VideoApi.Properties.Property, primary_key: true)
  end

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [:video_id, :property_id])
    |> foreign_key_constraint(:video_id)
    |> foreign_key_constraint(:property_id)
    |> unique_constraint(:unique_publication, name: :unique_publication)
  end
end
