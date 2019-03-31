defmodule VideoApi.Transcodings.TranscodingLog do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(level message)a

  schema "transcoding_logs" do
    field :level, ErrorLevelEnum
    field :message, :string
    belongs_to(:video, VideoApi.Videos.Video)
    timestamps()
  end

  @doc false
  def changeset(transcoding, attrs) do
    transcoding
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:video_id)
  end
end
