defmodule VideoApi.Publish do
  @moduledoc """
  The Properties context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo
  alias VideoApi.Properties
  alias VideoApi.Videos.Video
  alias VideoApi.Publish.Published
  alias VideoApi.Properties.Property

  def publish_videos_to_property(user, property, video_ids) when is_list(video_ids) do
    videos =
      Video
      |> where([video], video.id in ^video_ids and video.user_id == ^user.id)
      |> Repo.all()

    with {:ok, _struct} <-
           property
           |> Property.changeset_update_videos(videos)
           |> Repo.update() do
      {:ok, Properties.get_property(user, property.id)}
    else
      error -> error
    end
  end

  def publish_stats(user) do
    # video count
    query =
      from p in Published,
        select: count(p.video_id),
        join: v in Video,
        where: v.id == p.video_id and v.user_id == ^user.id

    count = Repo.one(query)

    %{count: count}
  end
end
