defmodule Stonex.Backoffice.Reports do
  @moduledoc """
  Reports is responsible for generating reports for the backoffice.
  """

  alias Stonex.Backoffice.Reports.{Annual, Daily, Monthly, Range, Total}

  @transaction_status "done"

  @doc """
  Creates a report for the given date range and type.

    ## Parameters

    `type`: The type of report to generate. Coulbe be one of above:
      \n- `Annual`
      \n- `Daily`
      \n- `Monthly`
      \n- `Range`:
        In cases of range report, the `from` and `to` parameters are required.
      \n- `Total`
  """
  def create(%{type: "range", from: "", to: ""}),
    do: {:error, "Reports of type range needs of a from and to datas."}

  def create(%{type: "range", from: from_date, to: to_date}),
    do: Range.send(@transaction_status, from_date, to_date)

  def create(%{type: "daily", from: _, to: _}), do: Daily.send(@transaction_status)
  def create(%{type: "monthly", from: _, to: _}), do: Monthly.send(@transaction_status)
  def create(%{type: "annual", from: _, to: _}), do: Annual.send(@transaction_status)
  def create(%{type: "total", from: _, to: _}), do: Total.send(@transaction_status)
  def create(%{type: type, from: _, to: _}), do: {:error, "Report #{type} is not available"}
end
