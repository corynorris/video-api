defmodule VideoApi.Accounts.Encryption do
  alias VideoApi.Accounts.User

  @spec password_hashing(binary()) :: any()
  def password_hashing(password), do: Bcrypt.hash_pwd_salt(password)

  @spec validate_dummy() :: false
  def validate_dummy(), do: Bcrypt.no_user_verify()

  @spec validate_password(User.t(), any()) ::
          {:error, String.t()} | {:ok, any()}
  def validate_password(%User{} = user, password),
    do: Bcrypt.check_pass(user, password, hash_key: :password)

  @spec hash_password(nil | binary()) :: any()
  def hash_password(nil), do: nil
  def hash_password(password), do: Bcrypt.hash_pwd_salt(password)
end
