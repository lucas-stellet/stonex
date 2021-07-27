defmodule Stonex.Backoffice.Reports.Total do
  @moduledoc """
  Total é um módulo com o intuito de apresentar
  uma interface mais simplificada para apresentar
  relatórios com todas as transações já existentes.
  """
  alias Stonex.Repo

  def send(status) do
    case commit_query(status) do
      {:ok, %{rows: [[result]]}} ->
        {:ok, "Total transacted: R$ #{result}"}

      {:ok, %{rows: [[nil]]}} ->
        {:ok, "Total transacted: R$ 0.00"}
    end
  end

  defp commit_query(status) do
    Repo.query(
      "SELECT SUM(transactions.value) FROM transactions WHERE transactions.status = $1;",
      [status]
    )
  end
end
