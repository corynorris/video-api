defmodule VideoApi.Transcodings do
  @moduledoc """
  The Transcodings context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo

  alias VideoApi.Transcodings.TranscodingLog

  @path_regex ~r/.*(\\|\/)/

  @doc """
  Returns the list of transcodings.

  ## Examples

      iex> list_transcodings()
      [%TranscodingLog{}, ...]

  """
  def list_transcodings(user, pagination) do
    user
    |> Ecto.assoc(:transcoding_logs)
    |> Ecto.Query.order_by(desc: :inserted_at)
    |> Repo.paginate(pagination)
  end

  @doc """
  Creates a transcoding.

  ## Examples

      iex> create_transcoding(%{field: value})
      {:ok, %TranscodingLog{}}

      iex> create_transcoding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def log(message, video, level \\ "info") do
    @path_regex
    |> Regex.replace(message, "[PATH]/")
    |> String.split("\n")
    |> Enum.each(fn message ->
      video
      |> Ecto.build_assoc(:transcoding_logs)
      |> TranscodingLog.changeset(%{
        message: message,
        level: level
      })
      |> Repo.insert()
    end)
  end
end
