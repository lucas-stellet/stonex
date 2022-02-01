defmodule Stonex.Accounts.Account do
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
    field :branch, :string, default: "1000"
    field :digit, :string

    belongs_to :user, Stonex.User

    timestamps()
  end

  @doc """
  Create an bank account with the given attributes and return a valid `Ecto.Changeset`.

  ## Parameters
  ```attrs```- The attributes to create the account with.
  """
  @spec build(map) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Schema.t()}
  def build(attrs) do
    attrs
    |> changeset()
    |> apply_action(:insert)
  end

  @spec changeset(struct(), map()) :: %Ecto.Changeset{}
  def changeset(account \\ %__MODULE__{}, attrs) do
    account
    |> cast(attrs, [:user_id, :branch, :balance])
    |> validate_required([:user_id])
    |> put_change(:number, create_account_number())
    |> put_change(:digit, create_account_digit())
  end

  defp create_account_number, do: Integer.to_string(Enum.random(100_000..999_999))
  defp create_account_digit, do: Integer.to_string(Enum.random(1..9))
end
