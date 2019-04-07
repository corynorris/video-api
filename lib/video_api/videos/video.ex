defmodule VideoApi.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @required_create_fields ~w(label video_file)a
  @optional_create_fields ~w(description)a
  @optional_update_fields ~w(label description)a
  @valid_mimes ~w(video/mp4)

  schema "videos" do
    field :label, :string
    field :description, :string
    field :video_file, :any, virtual: true
    field :content_type, :string
    field :filename, :string
    field :path, :string
    field :status, StatusEnum, default: 0
    belongs_to(:user, VideoApi.Accounts.User)
    has_many(:transcoding_logs, VideoApi.Transcodings.TranscodingLog)
    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, @required_create_fields ++ @optional_create_fields)
    |> validate_required(@required_create_fields)
    |> foreign_key_constraint(:user_id)
    |> validate_video_content_type(@valid_mimes)
    |> put_video_file_contents()
    |> unique_constraint(:unique_label, name: :unique_video_label)
  end

  def update_changeset(video, attrs) do
    video
    |> cast(attrs, @optional_update_fields)
    |> foreign_key_constraint(:user_id)
  end

  def update_status_changeset(video, attrs) do
    video
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end

  defp validate_video_content_type(changeset, content_types) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{video_file: video_file}} ->
        if not Enum.member?(content_types, video_file.content_type) do
          add_error(changeset, :video_file, "Invalid content type")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp put_video_file_contents(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{video_file: video_file}} ->
        path = Ecto.UUID.generate() <> Path.extname(video_file.filename)

        changeset
        |> put_change(:path, path)
        |> put_change(:filename, video_file.filename)
        |> put_change(:content_type, video_file.content_type)

      _ ->
        changeset
    end
  end
end
