defmodule VideoApi.Videos do
  @moduledoc """
  The Videos context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo
  alias VideoApi.Utils
  alias Ecto.Multi
  alias VideoApi.Videos.Video

  def video_stats(user) do
    # video count
    count = Repo.one(from v in "videos", select: count(v.id), where: v.user_id == ^user.id)

    # published count
    # count = Repo.one(from v in "videos", select: count(v.id), where: v.user_id == ^user.id and v.published==true)

    %{count: count, published: 0}
  end

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos(user, pagination) do
    Ecto.assoc(user, :videos)
    |> Repo.paginate(pagination)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video(user, video_id) do
    Repo.one(from v in Video, where: v.user_id == ^user.id and v.id == ^video_id)
  end

  @doc """
  Transaction to save, persist file, and start encoding

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(user, attrs \\ %{}) do
    user_video = Ecto.build_assoc(user, :videos)

    Multi.new()
    |> Multi.insert(:video, Video.changeset(user_video, attrs))
    |> Multi.run(:persist_file, fn _repo, %{video: video} ->
      persist_file(video, attrs["video_file"])
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{video: video}} ->
        Honeydew.async({:transcode, [video]}, :transcoding_jobs)
        {:ok, video}

      {:error, :video, changeset, _} ->
        {:error, changeset}

      {:error, :persist_file, _, _} ->
        {:error, "couldn't create file"}

      {:error, _, _, _} ->
        {:error, "Unknown error"}
    end
  end

  defp persist_file(video, %{path: temp_path}) do
    video_path = Utils.build_video_path(video)

    if File.exists?(video_path) do
      {:error, "File exists"}
    else
      video_path |> Path.dirname() |> File.mkdir_p()
      File.copy(temp_path, video_path)
    end
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video_status(%Video{} = video, status) do
    video
    |> Video.update_status_changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end
end
