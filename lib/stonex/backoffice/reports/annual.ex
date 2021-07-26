defmodule Stonex.Backoffice.Reports.Annual do
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
    today = Timex.format!(Timex.now(), "%Y-%m-%d", :strftime)
    [actual_year, _, _day] = String.split(today, "-")
    first_day_of_year = "#{actual_year}-01-01"

    from_date = Timex.parse!(first_day_of_year <> " 00:00:00", "{YYYY}-{0M}-{D} {h24}:{m}:{s}")

    to_date = Timex.parse!(today <> " 23:59:59", "{YYYY}-{0M}-{D} {h24}:{m}:{s}")

    Repo.query(
      "SELECT SUM(transactions.value) FROM transactions WHERE transactions.status = $1 AND transactions.inserted_at >= $2 and transactions.inserted_at <= $3 ;",
      [status, from_date, to_date]
    )
  end
end
