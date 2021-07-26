defmodule StonexWeb.AuthController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias StonexWeb.Auth.Guardian

  def login(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end

  def backoffice_login(conn, params) do
    with {:ok, token} <- Guardian.backoffice_authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("login.json", token: token)
    end
  end
end
