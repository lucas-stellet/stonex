defmodule Stonex do
  alias Stonex.Backoffice

  defdelegate get_reports(params), to: Backoffice.Reports, as: :call
end
