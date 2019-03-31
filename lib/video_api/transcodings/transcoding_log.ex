defmodule VideoApi.Transcodings.TranscodingLog do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(level message)a

  schema "transcoding_logs" do
    field :level, ErrorLevelEnum
    field :message, :string
    field :inserted_at, :utc_datetime
    belongs_to(:video, VideoApi.Videos.Video)
  end

  @doc false
  def changeset(transcoding, attrs) do
    transcoding
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:video_id)
    |> put_change(:inserted_at, DateTime.truncate(DateTime.utc_now(), :second))
  end
end
