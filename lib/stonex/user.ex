defmodule Stonex.User do
  @moduledoc """
  Schema de usuário.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_fields [:email, :first_name, :last_name, :password, :role, :document]

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :document, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :role, Ecto.Enum, values: [:admin, :client], default: :client

    has_one :account, Stonex.Account

    timestamps()
  end

  @doc """
  Builda um usuário com as informações fornecidas e devolve um `changeset`
  já validado.
  """
  @spec build(map) :: {:ok, %Ecto.Changeset{}} | {:error, %Ecto.Changeset{}}
  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  @spec changeset(map) :: %Ecto.Changeset{}
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/, message: "invalid format")
    |> validate_format(:document, ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/)
    |> validate_length(:password,
      min: 6,
      max: 8,
      message: "password has to be between 6 and 8 characters. "
    )
    |> update_change(:email, &String.downcase(&1))
    |> update_change(:first_name, &String.capitalize(&1))
    |> update_change(:last_name, &String.capitalize(&1))
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
