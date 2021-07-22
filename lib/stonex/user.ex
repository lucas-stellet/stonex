defmodule Stonex.User do
  @moduledoc """
  User cria um usuário sendo que, podendo ser tanto um usuário comum (`role`: `admin`)`client,
  quanto um usuário do backoffice (`role`: `admin`).
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
    |> unique_constraint(:email, name: :users_email_index)
    |> unique_constraint(:document, name: :users_document_index)
    |> validate_format(:email, ~r/@/, message: "invalid format")
    |> validate_format(:document, ~r/^\d{3}\.\d{3}\.\d{3}\-\d{2}$/)
    |> validate_length(:password,
      min: 6,
      max: 6,
      message: "password has to be between 6 and 15 characters. "
    )
    |> unique_constraint(:email, message: "e-mail account already registered")
    |> update_change(:email, &String.downcase(&1))
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
