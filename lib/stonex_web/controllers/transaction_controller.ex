defmodule StonexWeb.TransactionController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias Stonex.Accounts
  alias Stonex.Accounts.Account
  alias Stonex.Transactions.Transfers

  def transfer(conn, params) do
    with {:ok, message} <-
           Transfers.create_transfer(params) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, params) do
    with {:ok, message} <-
           Stonex.do_withdraw(params) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  end
end
