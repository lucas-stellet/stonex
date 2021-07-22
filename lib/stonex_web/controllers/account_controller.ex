defmodule StonexWeb.AccountController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias Stonex.Repo

  def create(conn, params) do
    with {:ok, %{id: user_id}} <- Stonex.create_user(params) do
      %{user_id: user_id}
      |> Stonex.create_account()
      |> handle_response(conn, "create.json", :created)
    end
  end

  defp handle_response({:ok, account}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, account: Repo.preload(account, :user))
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error
end
