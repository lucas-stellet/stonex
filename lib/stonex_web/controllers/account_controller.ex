defmodule StonexWeb.AccountController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias Stonex.Repo
  alias StonexWeb.Auth.Guardian
  alias Stonex.Users
  alias Stonex.Accounts

  def create(conn, params) do
    with {:ok, %{id: user_id} = user} <- Users.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         {:ok, account} <- Accounts.create_account(%{user_id: user_id}) do
      conn
      |> put_status(:created)
      |> render("create.json", %{account: Repo.preload(account, :user), token: token})
    end
  end
end
