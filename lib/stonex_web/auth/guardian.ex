defmodule StonexWeb.Auth.Guardian do
  use Guardian, otp_app: :stonex

  alias Stonex
  alias Stonex.Users
  alias Stonex.Users.User

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    user =
      claims
      |> Map.get("sub")
      |> Users.get_user_by_id()

    {:ok, user}
  end

  def authenticate(%{"document" => document, "password" => password}) do
    case Users.get_user_by(%{document: document}) do
      {:error, _} ->
        {:error, "Account not found!"}

      {:ok, user} ->
        validate_password(user, password)
    end
  end

  def backoffice_authenticate(%{"document" => document, "password" => password}) do
    with {:ok, user} <- Users.get_user_by(%{document: document}),
         {:ok, _user_admin} <- validate_admin_role(user) do
      validate_password(user, password)
    end
  end

  def validate_admin_role(%{role: role} = user) do
    cond do
      role == :admin -> {:ok, user}
      role == :client -> {:error, "User doesn't have permissions."}
    end
  end

  def validate_password(%User{password_hash: hash} = user, password) do
    case Argon2.verify_pass(password, hash) do
      true -> create_token(user)
      false -> {:error, :unauthorized}
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, token}
  end
end
