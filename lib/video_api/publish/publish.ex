defmodule VideoApi.Publish do
  @moduledoc """
  The Properties context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo

  alias VideoApi.Publish.Published

  def publish_stats(user) do
    # video count
    count = Repo.one(from p in "published", select: count(p.id), where: p.user_id == ^user.id)

    %{count: count}
  end

  @doc """
    Creates a relationship between a video and a property.

  ## Examples

      iex> publish_video(video, property)
      {:ok, %Published{}}

      iex> publish_video(video, property)
      {:error, %Ecto.Changeset{}}

  """
  def publish_video(video, property) do
  end
end
