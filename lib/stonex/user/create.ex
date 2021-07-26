defmodule Stonex.User.Create do
  @moduledoc """
  Create é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplicada na criação de novos usuarios.
  """

  alias Stonex.User
  alias Stonex.Repo

  def call(params) do
    case find_user(params) do
      :user_not_exist ->
        params
        |> User.build()
        |> create_user()

      :user_already_exists ->
        {:error, "User already exists!"}
    end
  end

  defp create_user({:ok, changeset}), do: Repo.insert(changeset)
  defp create_user({:error, _changeset} = error), do: error

  defp find_user(params) do
    case Repo.get_by(User, convert(params)) do
      nil ->
        :user_not_exist

      _user ->
        :user_already_exists
    end
  end

  defp convert(params) when is_map(params) do
    Enum.map(params, fn {key, value} -> {String.to_existing_atom(key), value} end)
    |> Keyword.delete(:password)
  end

  defp convert(params), do: params
end
