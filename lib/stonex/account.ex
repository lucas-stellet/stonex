defmodule Stonex.Account do
  @moduledoc """
  Schema de uma conta bancária.
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

  @doc """
  Builda uma conta bancária com as informações fornecidas e devolve um `changeset`
  já validado.
  """
  @spec build(map) :: {:ok, %Ecto.Changeset{}} | {:error, %Ecto.Changeset{}}
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  def changeset(params),
    do: create_changeset(%__MODULE__{}, merge_number_branch_digit_account(params))

  def changeset(account, params) do
    create_changeset(account, params)
  end

  @spec create_changeset(struct, map) :: %Ecto.Changeset{}
  defp create_changeset(account, params) do
    account
    |> cast(params, [:user_id, :number, :digit])
  end

  defp merge_number_branch_digit_account(map) do
    map
    |> Map.put(:number, Integer.to_string(Enum.random(100_000..999_999)))
    |> Map.put(:digit, Integer.to_string(Enum.random(1..9)))
  end
end
