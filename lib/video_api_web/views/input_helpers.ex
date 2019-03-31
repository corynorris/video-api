defmodule VideoApiWeb.InputHelpers do
  use Phoenix.HTML

  def error_level(level) do
    case level do
      :error -> "is-danger"
      :warning -> "is-warning"
      :success -> "is-success"
      :info -> "is-info"
      _ -> "is-primary"
    end
  end

  def brand_link(conn, path) do
    current_path = Path.join(["/" | conn.path_info])

    if path == current_path do
      "#"
    else
      path
    end
  end

  def active_class(conn, path) do
    current_path = Path.join(["/" | conn.path_info])

    if path == current_path do
      "is-active"
    else
      nil
    end
  end

  def active_link(conn, text, path, opts \\ []) do
    class =
      [opts[:class], active_class(conn, path)]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    opts =
      opts
      |> Keyword.put(:class, class)
      |> Keyword.put(:to, path)

    link(text, opts)
  end

  def input(form, field) do
    type = Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "field"]
    label_opts = [class: "label"]
    input_opts = [class: "input #{state_class(form, field)}"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = control(apply(Phoenix.HTML.Form, type, [form, field, input_opts]))
      error = VideoApiWeb.ErrorHelpers.error_tag(form, field)

      [label, input, error || ""]
    end
  end

  defp control(input) do
    content_tag :div, class: "control" do
      input
    end
  end

  def state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "is-danger"
      true -> "is-success"
    end
  end
end
