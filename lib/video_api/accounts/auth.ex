defmodule VideoApi.Accounts.Auth do
  alias VideoApi.Repo
  alias VideoApi.Accounts.{User, Encryption}
  import Ecto.Query, warn: false

  @spec sign_in(map()) :: {:ok, User.t()}
          | {:error, Ecto.Changeset.t() | :invalid_credentials}
  def sign_in(credentials \\ %{}) do
    %User{}
    |> User.sign_in_changeset(credentials)
    |> authenticate()
  end

  defp authenticate(%Ecto.Changeset{valid?: false} = changeset) do
    {:error, changeset}
  end

  @spec authenticate(Ecto.Changeset.t()) :: {:ok, User.t()} | {:error, :invalid_credentials}
  defp authenticate(%Ecto.Changeset{valid?: true, changes: %{email: email, password: password}}) do
    user = Repo.get_by(User, email: email)

    case Encryption.validate_password(user, password) do
      {:ok, _} -> {:ok, user}
      {:error, _} -> {:error, :invalid_credentials}
    end
  end
end
