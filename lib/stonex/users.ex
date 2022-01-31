defmodule Stonex.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Stonex.Repo

  alias Stonex.Users.User

  @doc """
  Returns a list of Users.

  ## Examples

      iex> Stonex.Users.list_users
      [%User{}, ...]

  """
  @spec list_users() :: [%User{}] | []
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user by id.

  Returns {:ok, %User{}} if queries successfully and {:error, "No user found"} if not.

  ## Parameters

  `id`: The id (Version 4 UUID) of the user to get.

  ## Examples

      iex> Stonex.Users.get_user_by_id("a0ece5db-cd14-4f21-812f-966633e7be86")
      {:ok, %User{}}

      iex> Stonex.Users.get_user_by_id("a0ece5db-cd14-4f21-123f-966633e7be86")
      {:error, "No user found}

  """
  @spec get_user_by_id(Ecto.UUID.t()) :: {:ok, %User{}} | {:error, binary()}
  def get_user_by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  Gets a single user by attrs.

  Returns {:ok, %User{}} if queries successfully and {:error, "No user found"} if not.

  ## Parameters

  `attrs`: The attributes of the user to get.

  ## Examples

      iex> Stonex.Users.get_by(%{name: "John Doe"})
      {:ok, %User{}}

      iex> Stonex.Users.get_by(%{name: "Unknown Person"})
      {:error, "No user found}

  """
  @spec get_user_by(list()) :: {:ok, %User{}} | {:error, binary()}
  def get_user_by(attrs) do
    case Repo.get_by(User, attrs) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Parameters

  `attrs`: The attributes of the user to create.

  ## Examples

      iex> Stonex.Users.create_user(%{field: value})
      {:ok, %User{}}

      iex> Stonex.Users.create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def create_user(attrs) do
    with {:error, "User not found"} <- get_user_by(convert(attrs)),
         {:ok, changeset} <- User.build(attrs) do
      Repo.insert(changeset)
    else
      {:ok, %User{}} ->
        {:error, "User already exists"}

      {:error, %Ecto.Changeset{}} = error ->
        error
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> Stonex.Users.update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> Stonex.Users.update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_user(%User{}, map()) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

   ## Parameters

  `user`:  User struct to delete.

  ## Examples

      iex> Stonex.Users.delete_user(user)
      {:ok, %User{}}

      iex> Stonex.Users.delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_user(%User{}) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  defp convert(params) when is_map(params) do
    Enum.map(params, &convert_key_to_string/1)
    |> Keyword.delete(:password)
  end

  defp convert_key_to_string({key, value}) when is_atom(key), do: {key, value}

  defp convert_key_to_string({key, value}) when is_binary(key),
    do: {String.to_existing_atom(key), value}
end
