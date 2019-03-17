defmodule VideoApi.Accounts.Users do
  @moduledoc """
  The Accounts context.
  """
  alias VideoApi.Repo
  alias VideoApi.Accounts.User

  import Ecto.Query, warn: false

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
