defmodule Stonex.Transactions.Withdraws do
  @moduledoc """
  Withdraws contains the logic for withdrawing money from a user's account.
  """

  alias Ecto.Multi
  alias Stonex.Accounts
  alias Stonex.Repo

  import Stonex.Transactions.Helpers

  require Logger

  def do_withdraw(params) do
    with {:ok, _validated_params} <-
           requester_account_balance_is_zero(:withdraw, params),
         {:ok, _validated_param} <- validate_withdrawable_balance(params) do
      new_requester_changeset = create_updated_account_changeset(params)

      Multi.new()
      |> Multi.update(:update_requester_account, new_requester_changeset)
      |> Repo.transaction()

      requester_email = params.requester_data.email

      send_email_confirmation(requester_email)

      insert_transaction(:withdraw, params, :done, "withdraw done")

      {:ok,
       "Withdraw done successfully. Receipt of withdrawal sent to email: #{requester_email} "}
    end
  end

  defp validate_withdrawable_balance(params) do
    requester_balance = params.requester_data.account_balance
    transfer_value = params.value

    case requester_balance_is_negative?(requester_balance, transfer_value) do
      false ->
        {:ok, params}

      true ->
        insert_transaction(:withdraw, params, :failed, "insufficient funds")

        {:error, "Was not possible complete your withdraw. Insufficient funds!"}
    end
  end

  defp create_updated_account_changeset(params) do
    requester_data = params.requester_data

    requester_new_balance = update_requester_balance(requester_data.account_balance, params.value)

    updated_changeset_account(requester_data.account_id, requester_new_balance)
  end

  defp updated_changeset_account(account_id, new_balance) do
    {:ok, account} = Accounts.get_account_by_id(account_id)

    Accounts.change_account(account, %{balance: new_balance})
  end

  defp send_email_confirmation(email) do
    Logger.debug(~s"""
     - - - - Receipt of withdrawal sent to email: #{email} - - - -
    """)
  end
end
