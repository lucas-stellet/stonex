defmodule Stonex.Transaction do
  @moduledoc """
  Schema for transactions
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  @required_fields ~w( value status beneficiary_id requester_id type)a
  @optional_fields ~w( observation description )a

  schema "transactions" do
    field :status, Ecto.Enum, values: [:done, :failed]
    field :type, Ecto.Enum, values: [:transfer, :withdraw]
    field :description, :string
    field :value, :decimal, precision: 16, scale: 2, default: 0.0
    field :beneficiary_id, Ecto.UUID
    field :requester_id, Ecto.UUID
    field :observation, :string, default: "done"

    timestamps(updated_at: false)
  end

  @doc """
  Build a transaction with the given information and returns a validated `changeset`.

  ## Parameters
  ```attrs```- The attributes to create the transaction with.
  """
  @spec build(map) :: {:ok, %Ecto.Changeset{}} | {:error, %Ecto.Changeset{}}
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_number(:value, greater_than_or_equal_to: Decimal.new(0))
  end
end
