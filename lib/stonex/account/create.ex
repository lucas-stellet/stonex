defmodule Stonex.Account.Create do
  @moduledoc """
  Create é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplicada na criação de novas contas.
  """

  alias Stonex.Account
  alias Stonex.Repo

  def call(params) do
    params
    |> Account.build()
    |> create_account()
  end

  defp create_account({:ok, changeset}), do: Repo.insert(changeset)
  defp create_account({:error, _changeset} = error), do: error
end
