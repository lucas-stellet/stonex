defmodule Stonex.Backoffice.Reports.Range do
  @moduledoc """
  Range é um módulo com o intuito de apresentar
  uma interface mais simplificada para apresentar
  relatórios com período personalizado.
  """

  alias Stonex.Repo

  def send(status, from_date, to_date) do
    case commit_query(status, from_date, to_date) do
      {:ok, %{rows: [[result]]}} ->
        {:ok, "Total transacted: R$ #{result}"}

      {:ok, %{rows: [[nil]]}} ->
        {:ok, "Total transacted: R$ 0.00"}
    end
  end

  defp commit_query(status, from_date, to_date) do
    from = Timex.parse!(from_date <> " 00:00:00", "{YYYY}-{0M}-{D} {h24}:{m}:{s}")
    to = Timex.parse!(to_date <> " 23:59:59", "{YYYY}-{0M}-{D} {h24}:{m}:{s}")

    Repo.query(
      "SELECT SUM(transactions.value) FROM transactions WHERE transactions.status = $1 AND transactions.inserted_at >= $2 and transactions.inserted_at <= $3 ;",
      [status, from, to]
    )
  end
end
