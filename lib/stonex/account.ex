defmodule Stonex.Account do
  @moduledoc """
  Creates a new bank account.
  """
  alias Stonex.Repo
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
    |> cast(params, [:number, :digit])
  end
end
