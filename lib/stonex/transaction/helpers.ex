defmodule Stonex.Transaction.Helpers do
  @moduledoc """
  Function helpers for transactions.
  """
  alias Stonex.Transaction
  alias Stonex.Repo

  def requester_account_balance_is_zero(
        type,
        %{"requester_info" => %{"balance" => balance}} = params
      ) do
    case Decimal.gt?(balance, 0) do
      false ->
        insert_transaction(
          type,
          Map.put(params, "id", params["requester_info"]["id"]),
          :failed,
          "zero balance"
        )

        {:error, "Transaction not allowed. Your account balance is eqaal zero. "}

      true ->
        {:ok, params}
    end
  end

  def insert_transaction(:transfer, params, status, observation) do
    {:ok, transaction} =
      %{
        value: params["value"],
        beneficiary_id: params["id"],
        requester_id: params["requester_info"]["id"],
        type: "transfer",
        status: status,
        observation: observation,
        description: params["description"]
      }
      |> Transaction.build()

    Repo.insert(transaction)
  end

  def insert_transaction(:withdraw, params, status, observation) do
    {:ok, transaction} =
      %{
        value: params["value"],
        beneficiary_id: params["requester_info"]["id"],
        requester_id: params["requester_info"]["id"],
        type: "withdraw",
        status: status,
        observation: observation,
        description: params["description"]
      }
      |> Transaction.build()

    Repo.insert(transaction)
  end

  def requester_balance_is_negative?(balance, value) when is_float(value) do
    Decimal.sub(balance, Decimal.from_float(value)) |> Decimal.negative?()
  end

  def requester_balance_is_negative?(balance, value) do
    Decimal.sub(balance, Decimal.new(value)) |> Decimal.negative?()
  end

  def put_multiple_recursive(map, []), do: map

  def put_multiple_recursive(map, [{key, value} | tl]) do
    Map.put(map, key, value)
    |> put_multiple_recursive(tl)
  end

  def update_requester_balance(balance, value) when is_float(value) do
    Decimal.sub(balance, Decimal.from_float(value))
    |> Decimal.to_float()
  end

  def update_requester_balance(balance, value) do
    Decimal.sub(balance, Decimal.new(value))
    |> Decimal.to_float()
  end

  def update_beneficiary_balance(balance, value) when is_float(value) do
    Decimal.add(balance, Decimal.from_float(value))
    |> Decimal.to_float()
  end

  def update_beneficiary_balance(balance, value) do
    Decimal.add(balance, Decimal.new(value))
    |> Decimal.to_float()
  end
end
