defmodule VideoApi.AuthTokens do
  @moduledoc """
  The AuthTokens context.
  """
  @length 30

  import Ecto.Query, warn: false
  alias VideoApi.Repo

  alias VideoApi.AuthTokens.AuthToken
  alias VideoApi.Properties.Property

  @doc """
  Gets a single auth_token.

  Raises `Ecto.NoResultsError` if the AuthToken does not exist.

  ## Examples

      iex> get_auth_token!(123)
      %AuthToken{}

      iex> get_auth_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_auth_token(user, auth_token_id) do
    query =
      from a in AuthToken,
        join: p in Property,
        where: a.property_id == p.id,
        where: a.id == ^auth_token_id and p.user_id == ^user.id

    Repo.one(query)
  end

  @doc """
  Lists auth tokens

  ## Examples
    iex> list_auth_tokens(property)
    [%AuthToken{}, ...]
  """
  def list_auth_tokens(property, pagination) do
    property
    |> Ecto.assoc(:auth_tokens)
    |> Ecto.Query.order_by(desc: :revoked_at)
    |> Repo.paginate(pagination)
  end

  @doc """
  Lists auth tokens

  ## Examples
    iex> list_auth_tokens(property)
    [%AuthToken{}, ...]
  """
  def list_auth_tokens(property, pagination) do
    property
    |> Ecto.assoc(:auth_tokens)
    |> Ecto.Query.order_by(desc: :revoked_at)
    |> Repo.paginate(pagination)
  end

  @doc """
  Generates an auth token

  ## Examples
    iex> generate_auth_token(user)
    {:ok, "kjoy3o1zeidquwy1398juxzldjlksahdk3"}
  """
  def generate_auth_token(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  @doc """
  Creates a auth_token.

  ## Examples

      iex> create_auth_token(%{field: value})
      {:ok, %AuthToken{}}

      iex> create_auth_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_auth_token(property) do
    property
    |> Ecto.build_assoc(:auth_tokens)
    |> AuthToken.changeset(%{
      token: generate_auth_token(@length)
    })
    |> Repo.insert()
  end

  @doc """
  Deletes a AuthToken.

  ## Examples

      iex> revoke_auth_token(auth_token)
      {:ok, %AuthToken{}}

      iex> revoke_auth_token(auth_token)
      {:error, %Ecto.Changeset{}}

  """
  def revoke_auth_token(auth_token) do
    auth_token
    |> AuthToken.revoke_changeset()
    |> Repo.update()
  end
end
