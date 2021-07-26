defmodule Stonex.Account.Get do
  @moduledoc """
  Get é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplificada para listar um `account`.
  """
  alias Stonex.Account
  alias Stonex.Repo

  def call(params) do
    params
    |> get()
  end

  defp get(params) do
    case Repo.get_by(Account, params) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  # defp convert(params) when is_map(params) do
  #   Enum.map(params, fn {key, value} -> {String.to_existing_atom(key), value} end)
  #   |> Keyword.delete(:password)
  # end

  # defp convert(params), do: params
end
