defmodule Stonex.Transactions.Transfers do
  @moduledoc """
  Transfers contains the logic for transferring between accounts.
  """

  alias Ecto.Multi
  alias Stonex.Accounts
  alias Stonex.Repo
  alias Stonex.Transactions.Transfers.Transfer

  import Stonex.Transactions.Helpers

  @doc """
  Creates a transfer between two accounts.
  """
  @spec do_transfer(%Transfer{}) :: {:ok, binary()} | {:error, binary()}
  def do_transfer(params) do
    with {:ok, _validated_params} <-
           requester_account_balance_is_zero(:transfer, params),
         {:ok, _validated_params} <-
           requester_is_equal_beneficiary(params),
         {:ok, validated_beneficiary_transfer} <- validate_beneficiary(params),
         {:ok, _validated_param} <-
           validate_transferable_balance(validated_beneficiary_transfer) do
      {beneficiary_changeset, requester_changeset} =
        create_updated_accounts_changesets(validated_beneficiary_transfer)

      Multi.new()
      |> Multi.update(:update_beneficiary_account, beneficiary_changeset)
      |> Multi.update(:update_requester_account, requester_changeset)
      |> Repo.transaction()

      insert_transaction(:transfer, validated_beneficiary_transfer, :done, "transfer done")

      {:ok, "Transfer done successfully!"}
    end
  end

  defp validate_beneficiary(params) do
    %{account_branch: branch, account_number: number, account_digit: digit, document: document} =
      params.beneficiary_data

    with {:ok, account} <-
           Accounts.get_account_by(branch: branch, digit: digit, number: number),
         account_user_loaded <- Repo.preload(account, :user) do
      updated_params =
        put_multiple_recursive(params, [
          {:beneficiary_data, [{:account_id, account.id}, {:account_balance, account.balance}]}
        ])

      case user_document_is_valid?(account_user_loaded, document) do
        true ->
          {:ok, updated_params}

        false ->
          insert_transaction(
            :transfer,
            updated_params,
            :failed,
            "invalid information"
          )

          {:error, "Account informations are not valid!"}
      end
    end
  end

  defp requester_is_equal_beneficiary(params) do
    beneficiary_data = params.beneficiary_data
    requester_data = params.requester_data

    case requester_data.document == beneficiary_data.document do
      true -> {:error, "Not is possible transfer money to yourself. "}
      false -> {:ok, params}
    end
  end

  defp validate_transferable_balance(params) do
    transfer_value = params.value
    requester_balance = params.requester_data.account_balance

    case requester_balance_is_negative?(requester_balance, transfer_value) do
      false ->
        {:ok, params}

      true ->
        insert_transaction(:transfer, params, :failed, "insufficient funds")

        {:error, "Was not possible complete your transfer. Insufficient funds!"}
    end
  end

  defp user_document_is_valid?(%{user: user}, document), do: user.document == document

  defp create_updated_accounts_changesets(params) do
    requester_data = params.requester_data
    beneficiary_data = params.beneficiary_data

    new_beneficiary_balance =
      update_beneficiary_balance(beneficiary_data.account_balance, params.value)

    new_requester_balance = update_requester_balance(requester_data.account_balance, params.value)

    new_beneficiary_changeset =
      updated_changeset_account(beneficiary_data, new_beneficiary_balance)

    new_requester_changeset = updated_changeset_account(requester_data, new_requester_balance)

    {new_beneficiary_changeset, new_requester_changeset}
  end

  defp updated_changeset_account(%{account_id: account_id}, new_balance) do
    {:ok, account} = Accounts.get_account_by_id(account_id)

    Accounts.change_account(account, %{balance: new_balance})
  end
end
