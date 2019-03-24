defmodule VideoApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias VideoApi.Accounts.Encryption

  @sign_up_fields ~w(first_name last_name email password)a
  @sign_in_fields ~w(email password)a
  @update_fields ~w(first_name last_name email)a
  @email ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string

    timestamps()
  end

  def invalid_credentials(changeset) do
    changeset
    |> add_error(:email, "invalid email or password")
    |> add_error(:password, "invalid email or password")
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @sign_up_fields)
    |> validate_required(@sign_up_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email)
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:email, message: "Email already exists")
    |> update_change(:password, &Encryption.hash_password/1)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, @update_fields)
    |> validate_required(@update_fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email)
    |> unique_constraint(:email, message: "Email already exists")
  end

  def sign_in_changeset(user, attrs) do
    user
    |> cast(attrs, @sign_in_fields)
    |> validate_required(@sign_in_fields)
    |> validate_format(:email, @email)
    |> update_change(:email, &String.downcase/1)
  end
end
