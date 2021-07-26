defmodule Stonex.Transaction.Withdraw.Create do
  alias Stonex.Repo
  alias Ecto.Multi
  import Stonex.Transaction.Helpers
  require Logger

  def call(params) do
    with {:ok, validated_withdraw_data} <-
           check_if_requester_account_balance_is_zero(:withdraw, params),
         {:ok, validated_withdraw} <- validate_withdrawable_balance(validated_withdraw_data),
         {:ok, requester_changeset} <- create_updated_account_changeset(validated_withdraw) do
      Multi.new()
      |> Multi.update(:update_requester_account, requester_changeset)
      |> Repo.transaction()

      send_email_confirmation(validated_withdraw)

      insert_transaction(:withdraw, validated_withdraw, :done, "withdraw done")

      {:ok, "Withdraw done successfully!"}
    end
  end

  defp validate_withdrawable_balance(
         %{
           "value" => transfer_value,
           "requester_info" => %{"balance" => requester_balance}
         } = params
       ) do
    case requester_balance_is_negative?(requester_balance, transfer_value) do
      false ->
        {:ok,
         put_in(
           params["requester_info"]["new_balance"],
           update_requester_balance(requester_balance, transfer_value)
         )}

      true ->
        insert_transaction(:withdraw, params, :failed, "insufficient funds")

        {:error, "Was not possible complete your withdraw.Insufficient funds!"}
    end
  end

  defp create_updated_account_changeset(%{
         "requester_info" => %{
           "new_balance" => requester_new_balance,
           "account_id" => requester_account_id
         }
       }) do
    requester_changeset = updated_changeset_account(requester_account_id, requester_new_balance)

    {:ok, requester_changeset}
  end

  defp updated_changeset_account(id, balance) do
    updated_changeset = Stonex.update_account(%{id: id, balance: balance})

    updated_changeset
  end

  defp send_email_confirmation(%{"requester_info" => %{"email" => email}}) do
    Logger.debug(~s"""
     - - - - Receipt of withdrawal sent to email: #{email} - - - -
    """)
  end
end
