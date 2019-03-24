defmodule VideoApi.Transcodings do
  @moduledoc """
  The Transcodings context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo

  alias VideoApi.Transcodings.Transcoding

  @doc """
  Returns the list of transcodings.

  ## Examples

      iex> list_transcodings()
      [%Transcoding{}, ...]

  """
  def list_transcodings do
    Repo.all(Transcoding)
  end

  @doc """
  Gets a single transcoding.

  Raises `Ecto.NoResultsError` if the Transcoding does not exist.

  ## Examples

      iex> get_transcoding!(123)
      %Transcoding{}

      iex> get_transcoding!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transcoding!(id), do: Repo.get!(Transcoding, id)

  @doc """
  Creates a transcoding.

  ## Examples

      iex> create_transcoding(%{field: value})
      {:ok, %Transcoding{}}

      iex> create_transcoding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transcoding(attrs \\ %{}) do
    %Transcoding{}
    |> Transcoding.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transcoding.

  ## Examples

      iex> update_transcoding(transcoding, %{field: new_value})
      {:ok, %Transcoding{}}

      iex> update_transcoding(transcoding, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transcoding(%Transcoding{} = transcoding, attrs) do
    transcoding
    |> Transcoding.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Transcoding.

  ## Examples

      iex> delete_transcoding(transcoding)
      {:ok, %Transcoding{}}

      iex> delete_transcoding(transcoding)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transcoding(%Transcoding{} = transcoding) do
    Repo.delete(transcoding)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transcoding changes.

  ## Examples

      iex> change_transcoding(transcoding)
      %Ecto.Changeset{source: %Transcoding{}}

  """
  def change_transcoding(%Transcoding{} = transcoding) do
    Transcoding.changeset(transcoding, %{})
  end
end
