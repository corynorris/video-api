defmodule VideoApi.Json do
  @moduledoc """
  The Videos context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo
  alias VideoApi.Videos.Video
  alias VideoApi.AuthTokens.AuthToken
  alias VideoApi.Properties.Property
  alias VideoApi.Publish.Published

  @doc """
  Lists all videos for a given auth token
  """
  def list_videos(auth_token) do
    query =
      from vid in Video,
        join: pub in Published,
        join: auth in AuthToken,
        where: auth.property_id == pub.property_id,
        where: pub.video_id == vid.id,
        where: auth.token == ^auth_token and auth.revoked == false

    Repo.all(query)
  end

  @doc """
  Lists all properties for a given auth token
  """
  def get_property(auth_token) do
    query =
      from prop in Property,
        join: auth in AuthToken,
        where: auth.property_id == prop.id,
        where: auth.token == ^auth_token and auth.revoked == false

    Repo.one(query)
  end

  @doc """
  Gets a given video from an auth token
  """
  def get_video(auth_token, video_id) do
    query =
      from vid in Video,
        join: pub in Published,
        join: auth in AuthToken,
        where: auth.property_id == pub.property_id,
        where: pub.video_id == vid.id and vid.id == ^video_id,
        where: auth.token == ^auth_token and auth.revoked == false

    Repo.one(query)
  end
end
