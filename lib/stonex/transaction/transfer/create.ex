defmodule Stonex.Transaction.Transfer.Create do
  alias Stonex.Repo
  alias Ecto.Multi
  import Stonex.Transaction.Helpers

  def call(params) do
    with {:ok, validated_transfer_data} <-
           check_if_requester_account_balance_is_zero(:transfer, params),
         {:ok, tranfer_data} <- validate_beneficiary(validated_transfer_data),
         {:ok, validated_transfer} <-
           validate_transferable_balance(tranfer_data),
         [beneficiary_changeset, requester_changeset] <-
           create_updated_accounts_changesets(validated_transfer) do
      Multi.new()
      |> Multi.update(:update_beneficiary_account, beneficiary_changeset)
      |> Multi.update(:update_requester_account, requester_changeset)
      |> Repo.transaction()

      insert_transaction(:transfer, validated_transfer, :done, "transfer done")
      {:ok, "Transfer done successfully!"}
    end
  end

  defp validate_beneficiary(
         %{
           "account" => %{"branch" => branch, "digit" => digit, "number" => number},
           "document" => document
         } = params
       ) do
    with {:ok, account} <- Stonex.get_account(%{branch: branch, digit: digit, number: number}),
         account_user_loaded <- Repo.preload(account, :user) do
      case user_document_is_valid?(account_user_loaded, document) do
        true ->
          {:ok,
           put_multiple_recursive(params, [
             {"id", account.user_id},
             {"account_id", account.id},
             {"balance", account.balance}
           ])}

        false ->
          insert_transaction(
            :transfer,
            Map.put(params, "id", account.id),
            :failed,
            "invalid information"
          )

          {:error, "Account informations are not valid!"}
      end
    end
  end

  defp validate_transferable_balance(
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
        insert_transaction(:transfer, params, :failed, "insufficient funds")

        {:error, "Was not possible complete your transfer.Insufficient funds!"}
    end
  end

  defp user_document_is_valid?(%{user: user}, document), do: user.document == document

  defp create_updated_accounts_changesets(%{
         "account_id" => beneficiary_account_id,
         "balance" => beneficiary_balance,
         "value" => transfer_value,
         "requester_info" => %{
           "new_balance" => requester_new_balance,
           "account_id" => requester_account_id
         }
       }) do
    beneficiary_changeset =
      updated_changeset_account(
        beneficiary_account_id,
        update_beneficiary_balance(beneficiary_balance, transfer_value)
      )

    requester_changeset = updated_changeset_account(requester_account_id, requester_new_balance)

    [beneficiary_changeset, requester_changeset]
  end

  defp updated_changeset_account(id, balance) do
    updated_changeset = Stonex.update_account(%{id: id, balance: balance})

    updated_changeset
  end
end
