defmodule Stonex.Backoffice.Reports.Total do
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
