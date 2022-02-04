defmodule Stonex.Transactions.Helpers do
  @moduledoc """
  Function helpers for transactions.
  """
  alias Stonex.Repo
  alias Stonex.Transactions.Transaction

  def requester_account_balance_is_zero(
        type,
        %{requester_data: %{account_balance: account_balance}} = params
      ) do
    case Decimal.gt?(account_balance, 0) do
      false ->
        insert_transaction(
          type,
          params,
          :failed,
          "zero balance"
        )

        {:error, "Transaction not allowed. Your account balance is eqaal zero. "}

      true ->
        {:ok, params}
    end
  end

  def insert_transaction(:transfer, params, status, observation) do
    requester_data = params.requester_data
    beneficiary_data = params.beneficiary_data

    {:ok, transaction} =
      %{
        value: params.value,
        beneficiary_id: Map.get(beneficiary_data, :account_id),
        requester_id: requester_data.account_id,
        type: "transfer",
        status: status,
        observation: observation,
        description: params.description
      }
      |> Transaction.build()

    Repo.insert(transaction)
  end

  def insert_transaction(:withdraw, params, status, observation) do
    requester_data = params.requester_data

    {:ok, transaction} =
      %{
        value: params.value,
        beneficiary_id: requester_data.id,
        requester_id: requester_data.id,
        type: "withdraw",
        status: status,
        observation: observation,
        description: params.description
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

  def put_multiple_recursive(map, [{_key, []}]), do: map

  def put_multiple_recursive(map, [{key, [{k, v} | kv_tl]} | tl]) do
    key_map_to_update = Map.get(map, key)

    Map.put(map, key, Map.put(key_map_to_update, k, v))
    |> put_multiple_recursive([{key, kv_tl}])
    |> put_multiple_recursive(tl)
  end

  def put_multiple_recursive(map, [{key, value} | tl]) do
    Map.put(map, key, value)
    |> put_multiple_recursive(tl)
  end

  def update_requester_balance(balance, value) when is_float(value) do
    Decimal.sub(balance, Decimal.from_float(value))
    |> Decimal.to_float()
  end

  def update_requester_balance(balance, value) do
    IO.inspect(value)

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
