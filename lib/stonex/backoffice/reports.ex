defmodule Stonex.Backoffice.Reports do
  alias Stonex.Backoffice.Reports.{Daily, Monthly, Annual, Total, Range}

  @transaction_status "done"

  def call(%{type: "range", from: from_date, to: to_date}),
    do: Range.send(@transaction_status, from_date, to_date)

  def call(%{type: "daily", from: _, to: _}), do: Daily.send(@transaction_status)
  def call(%{type: "monthly", from: _, to: _}), do: Monthly.send(@transaction_status)
  def call(%{type: "annual", from: _, to: _}), do: Annual.send(@transaction_status)
  def call(%{type: "total", from: _, to: _}), do: Total.send(@transaction_status)
end
