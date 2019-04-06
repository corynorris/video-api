defmodule VideoApiWeb.LayoutView do
  use VideoApiWeb, :view

  def unique_view_name(view_module, view_template) do
    [_elixir, _app | context_controller_template] =
      view_module |> Phoenix.Naming.humanize() |> String.split(".")

    [action, "html"] = view_template |> String.split(".")

    Enum.join(context_controller_template ++ [action], "_")
  end
end
