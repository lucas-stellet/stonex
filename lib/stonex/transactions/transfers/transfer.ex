defmodule Stonex.Transactions.Transfers.Transfer do
  @moduledoc """
  Transfer struct.
  """

  @enforce_keys ~w( beneficiary_data value requester_data )a

  @type t :: %__MODULE__{
          beneficiary_data: map(),
          requester_data: map(),
          value: binary() | Decimal.t(),
          description: binary()
        }

  defstruct @enforce_keys ++ [:description]

  @doc """
  Build a new transfer struct.
  """
  @spec build(map()) :: __MODULE__.t()
  def build(attrs) do
    validate_beneficiary_data!(attrs)

    %__MODULE__{
      beneficiary_data: %{
        account_branch: attrs["account"]["branch"],
        account_number: attrs["account"]["number"],
        account_digit: attrs["account"]["digit"],
        document: attrs["document"]
      },
      requester_data: attrs.requester_data,
      value: attrs["value"],
      description: attrs["description"] || ""
    }
  end

  defp validate_beneficiary_data!(attrs) do
    case has_keys?(attrs) do
      true ->
        nil

      false ->
        raise ArgumentError, "Beneficiary account has missing data"
    end
  end

  defp has_keys?(attrs) do
    Map.has_key?(attrs, "document") and
      Map.has_key?(attrs, "account") and
      Map.has_key?(attrs["account"], "branch") and
      Map.has_key?(attrs["account"], "digit") and
      Map.has_key?(attrs["account"], "number")
  end
end
