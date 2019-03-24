defmodule VideoApi.Transcodings.Transcoding do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transcodings" do
    field :video_1080p, :string
    field :video_360p, :string
    field :video_420p, :string
    field :video_720p, :string
    field :video_id, :id

    timestamps()
  end

  @doc false
  def changeset(transcoding, attrs) do
    transcoding
    |> cast(attrs, [:video_1080p, :video_720p, :video_420p, :video_360p])
    |> validate_required([:video_1080p, :video_720p, :video_420p, :video_360p])
  end
end
