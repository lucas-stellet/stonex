defmodule Stonex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Stonex.Repo

  alias Stonex.Accounts.Account

  @doc """
  Returns a list of accounts.

  ## Examples

      iex> Stonex.Accounts.list_accounts
      [%Account{}, ...]

  """
  @spec list_accounts() :: [%Account{}] | []
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account by id.

  Returns {:ok, %Account{}} if queries successfully and {:error, "No account found"} if not.

  ## Parameters

  `id`: The id (Version 4 UUID) of the account to get.

  ## Examples

      iex> Stonex.Accounts.get_account("a0ece5db-cd14-4f21-812f-966633e7be86")
      {:ok, %Account{}}
      {:ok, }%Account{}}

      iex> Stonex.Accounts.get_account("a0ece5db-cd14-4f21-123f-966633e7be86")
      {:error, "No account found}

  """
  @spec get_account_by_id(Ecto.UUID.t()) :: {:ok, %Account{}} | {:error, binary()}
  def get_account_by_id(id) do
    case Repo.get(Account, id) do
      nil -> {:error, "Account not found"}
      account -> {:ok, account}
    end
  end

  @doc """
  Gets a single account by attrs.

  Returns {:ok, %Account{}} if queries successfully and {:error, "No account found"} if not.

  ## Parameters

  `attrs`: The attributes of the account to get.

  ## Examples

      iex> Stonex.Account.get_account_by(%{name: "John Doe"})
      {:ok, %User{}}

      iex> Stonex.Account.get_account_by(%{name: "Unknown Person"})
      {:error, "No user found}

  """
  @spec get_account_by(list()) :: {:ok, %Account{}} | {:error, binary()}
  def get_account_by(attrs) do
    case Repo.get_by(Account, attrs) do
      nil -> {:error, "Account not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a account.

  ## Parameters

  `attrs`: The attributes of the account to create.

  ## Examples

      iex> Stonex.Accounts.create_account(%{field: value})
      {:ok, %Account{}}

      iex> Stonex.Accounts.create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_account(map()) :: {:ok, %Account{}} | {:error, %Ecto.Changeset{}}
  def create_account(attrs) do
    case Account.build(attrs) do
      {:ok, changeset} -> Repo.insert(changeset)
      {:error, _changeset} = error -> error
    end
  end

  @doc """
  Updates a account.

  ## Examples

      iex> Stonex.Accounts.update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> Stonex.Accounts.update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_account(%Account{}, map()) :: {:ok, %Account{}} | {:error, %Ecto.Changeset{}}
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

   ## Parameters

  `account`:  Anccount struct to delete.

  ## Examples

      iex> Stonex.Accounts.delete_account(account)
      {:ok, %Account{}}

      iex> Stonex.Accounts.delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_account(%Account{}) :: {:ok, %Account{}} | {:error, %Ecto.Changeset{}}
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end
end
