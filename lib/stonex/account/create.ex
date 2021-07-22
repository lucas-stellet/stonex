defmodule Stonex.Account.Create do
  @moduledoc """
  Create é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplicada na criação de novas contas.
  """

  alias Stonex.Account
  alias Stonex.Repo

  def call(%{user_id: user_id}) do
    account_body = generate_number_digit_account()

    Map.put(account_body, :user_id, user_id)
    |> Account.build()
    |> create_account()
  end

  defp create_account({:ok, changeset}), do: Repo.insert(changeset)
  defp create_account({:error, _changeset} = error), do: error

  defp generate_number_digit_account do
    %{}
    |> Map.put(:number, Integer.to_string(Enum.random(100_000..999_999)))
    |> Map.put(:digit, Integer.to_string(Enum.random(1..9)))
  end
end
