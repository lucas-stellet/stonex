defmodule Stonex.Account.Update do
  @moduledoc """
  Update é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplificada para listar um `account`.
  """
  alias Stonex.Account
  alias Stonex.Repo

  def call(params) do
    params
    |> update()
  end

  defp update(%{id: id} = params) do
    case fetch_account(id) do
      nil ->
        {:error, "Account not found!"}

      account ->
        change_account(account, params)
    end
  end

  defp fetch_account(id), do: Repo.get(Account, id)

  defp change_account(account, params) do
    account
    |> Ecto.Changeset.change(params)
  end
end
