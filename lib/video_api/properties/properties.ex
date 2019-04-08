defmodule VideoApi.Properties do
  @moduledoc """
  The Properties context.
  """

  import Ecto.Query, warn: false
  alias VideoApi.Repo

  alias VideoApi.Properties.Property

  def property_stats(user) do
    # video count
    count = Repo.one(from v in "properties", select: count(v.id), where: v.user_id == ^user.id)

    %{count: count}
  end

  @doc """
  Returns the list of properties.

  ## Examples

      iex> list_properties()
      [%Property{}, ...]

  """
  def list_properties(user, pagination) do
    Ecto.assoc(user, :properties)
    |> Repo.paginate(pagination)
  end

  def list_properties(user) do
    Ecto.assoc(user, :properties)
    |> Repo.all()
  end

  @doc """
  Gets a single property.

  Raises `Ecto.NoResultsError` if the Property does not exist.

  ## Examples

      iex> get_property!(123)
      %Property{}

      iex> get_property!(456)
      ** (Ecto.NoResultsError)

  """
  def get_property(user, property_id) do
    Repo.one(from v in Property, where: v.user_id == ^user.id and v.id == ^property_id)
    |> Repo.preload(:videos)
  end

  @doc """
  Creates a property.

  ## Examples

      iex> create_property(%{field: value})
      {:ok, %Property{}}

      iex> create_property(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_property(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:properties)
    |> Property.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a property.

  ## Examples

      iex> update_property(property, %{field: new_value})
      {:ok, %Property{}}

      iex> update_property(property, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Property.

  ## Examples

      iex> delete_property(property)
      {:ok, %Property{}}

      iex> delete_property(property)
      {:error, %Ecto.Changeset{}}

  """
  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking property changes.

  ## Examples

      iex> change_property(property)
      %Ecto.Changeset{source: %Property{}}

  """
  def change_property(%Property{} = property) do
    Property.changeset(property, %{})
  end
end
