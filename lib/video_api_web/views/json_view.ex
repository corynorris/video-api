defmodule VideoApiWeb.JsonView do
  use VideoApiWeb, :view
  import VideoApi.Utils
  alias VideoApiWeb.JsonView

  def render("index.json", %{properties: properties, videos: videos}) do
    %{
      properties: render_many(properties, JsonView, "property.json", as: :property),
      videos: render_many(videos, JsonView, "video.json", as: :video)
    }
  end

  def render("videos.json", %{videos: videos}) do
    %{
      videos: render_many(videos, JsonView, "video.json", as: :video)
    }
  end

  def render("video.json", %{video: video}) do
    video
    |> Map.from_struct()
    |> Map.take([:id, :label, :description, :content_type, :status])
    |> Map.put(:url, build_video_url(video))
  end

  def render("property.json", %{property: property}) do
    property
    |> Map.from_struct()
    |> Map.take([:id, :label, :description, :url])
  end
end
