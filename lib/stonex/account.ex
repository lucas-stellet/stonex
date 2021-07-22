defmodule Stonex.Account do
  @moduledoc """
  Creates a new bank account.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type Ecto.UUID

  schema "accounts" do
    field :balance, :decimal, precision: 10, scale: 2, default: 1000
    field :number, :string
    field :branch, :string, default: "0001"
    field :digit, :string

    belongs_to :user, Stonex.User

    timestamps()
  end

  @spec build(map) :: {:ok, %Ecto.Changeset{}} | {:error, %Ecto.Changeset{}}
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  @spec changeset(map) :: %Ecto.Changeset{}
  def changeset(params) do
    %__MODULE__{}
    |> cast(merge_number_branch_digit_account(params), [:user_id, :number, :digit])
  end

  defp merge_number_branch_digit_account(map) do
    map
    |> Map.put(:number, Integer.to_string(Enum.random(100_000..999_999)))
    |> Map.put(:digit, Integer.to_string(Enum.random(1..9)))
  end
end
