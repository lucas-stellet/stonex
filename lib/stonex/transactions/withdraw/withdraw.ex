defmodule Stonex.Transactions.Withdraws.Withdraw do
  @moduledoc """
  Withdraw struct.
  """

  @enforce_keys ~w( value requester_data )a

  @type t :: %__MODULE__{
          requester_data: map(),
          value: binary() | Decimal.t()
        }

  defstruct @enforce_keys ++ [:description]

  @doc """
  Build a new withdraws struct.
  """
  @spec build(map()) :: __MODULE__.t()
  def build(attrs) do
    %__MODULE__{
      requester_data: attrs.requester_data,
      value: attrs["value"]
    }
  end
end
