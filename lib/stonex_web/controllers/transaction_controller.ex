defmodule StonexWeb.TransactionController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias Stonex.Transactions.Transfers
  alias Stonex.Transactions.Transfers.Transfer
  alias Stonex.Transactions.Withdraws
  alias Stonex.Transactions.Withdraws.Withdraw

  def transfer(conn, params) do
    transfer_attrs = Map.merge(params, conn.assigns)

    with transfer_struct <- Transfer.build(transfer_attrs),
         {:ok, message} <- Transfers.do_transfer(transfer_struct) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  def withdraw(conn, params) do
    withdraw_attrs = Map.merge(params, conn.assigns)

    with withdraw_struct <- Withdraw.build(withdraw_attrs),
         {:ok, message} <-
           Withdraws.do_withdraw(withdraw_struct) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  end
end
