defmodule VideoApiWeb.JsonView do
  use VideoApiWeb, :view
  alias VideoApiWeb.JsonView

  def render("index.json", %{properties: properties, videos: videos}) do
    %{
      properties: render_many(properties, JsonView, "property.json", as: :property),
      videos: render_many(videos, JsonView, "video.json", as: :video)
    }
  end

  def render("video.json", %{video: video}) do
    video
    |> Map.from_struct()
    |> Map.take([:id, :label, :description, :content_type, :status])
  end

  def render("property.json", %{property: property}) do
    property
    |> Map.from_struct()
    |> Map.take([:id, :label, :description, :url])
  end
end
