defmodule VideoApi.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(title video_file)a
  @optional_fields ~w(description)a
  @valid_mimes ~w(video/mp4)

  schema "videos" do
    field :title, :string
    field :description, :string
    field :video_file, :any, virtual: true
    field :content_type, :string
    field :filename, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_video_content_type(@valid_mimes)
    |> put_video_file_contents()
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
