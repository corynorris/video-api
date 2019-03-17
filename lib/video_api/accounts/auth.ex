defmodule VideoApi.Accounts.Auth do
  alias VideoApi.Repo
  alias VideoApi.Accounts.{User, Encryption}
  import Ecto.Query, warn: false

  def sign_in(credentials \\ %{}) do
    %User{}
    |> User.sign_in_changeset(credentials)
    |> authenticate()
  end

  defp authenticate(%Ecto.Changeset{valid?: false} = changeset) do
    {:error, changeset}
  end

  defp authenticate(%Ecto.Changeset{valid?: true, changes: %{email: email, password: password}}) do
    Repo.get_by(User, email: email)
    |> Encryption.validate_password(password)
  end
end
