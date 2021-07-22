defmodule Stonex.User.Create do
  @moduledoc """
  Create é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplicada na criação de novos usuarios.
  """

  alias Stonex.User
  alias Stonex.Repo

  def call(params) do
    params
    |> User.build()
    |> create_user()
  end

  defp create_user({:ok, changeset}), do: Repo.insert(changeset)
  defp create_user({:error, _changeset} = error), do: error
end
