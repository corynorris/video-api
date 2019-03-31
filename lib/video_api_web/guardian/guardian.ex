defmodule VideoApiWeb.Guardian do
  use Guardian, otp_app: :video_api

  alias VideoApi.Accounts.Users

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user(id) do
      nil ->
        {:error, :resource_not_found}

      user ->
        {:ok, user}
    end
  end
end
