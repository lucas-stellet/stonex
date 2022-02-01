defmodule Stonex.Transaction.Transfers do
  @moduledoc """
  Transfers contains the logic for transferring between accounts.
  """

  alias Ecto.Multi
  alias Stonex.Accounts
  alias Stonex.Repo

  import Stonex.Transaction.Helpers

  @doc """
  Creates a transfer between two accounts.
  """
  @spec create_transfer(map()) :: {:ok, binary()} | {:error, binary()}
  def create_transfer(params) do
    with {:ok, validated_transfer_data} <-
           requester_account_balance_is_zero(:transfer, params),
         {:ok, requester_different_transfer_data} <-
           requester_is_equal_beneficiary(validated_transfer_data),
         {:ok, tranfer_data} <- validate_beneficiary(requester_different_transfer_data),
         {:ok, validated_balance_transfer} <-
           validate_transferable_balance(tranfer_data),
         [beneficiary_changeset, requester_changeset] <-
           create_updated_accounts_changesets(validated_balance_transfer) do
      Multi.new()
      |> Multi.update(:update_beneficiary_account, beneficiary_changeset)
      |> Multi.update(:update_requester_account, requester_changeset)
      |> Repo.transaction()

      insert_transaction(:transfer, validated_balance_transfer, :done, "transfer done")

      {:ok, "Transfer done successfully!"}
    end
  end

  defp validate_beneficiary(
         %{
           "account" => %{"branch" => branch, "digit" => digit, "number" => number},
           "document" => document
         } = params
       ) do
    with {:ok, account} <-
           Accounts.get_account_by(%{branch: branch, digit: digit, number: number}),
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

  defp requester_is_equal_beneficiary(
         %{
           "document" => beneficiary_document,
           "requester_info" => %{"document" => requester_dcument}
         } = params
       ) do
    case requester_dcument == beneficiary_document do
      true -> {:error, "Not is possible transfer money to yourself. "}
      false -> {:ok, params}
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
    {:ok, account} = Accounts.get_account_by_id(id)

    updated_changeset = Accounts.update_account(account, %{id: id, balance: balance})

    updated_changeset
  end
end
