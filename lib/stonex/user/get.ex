defmodule Stonex.User.Get do
  @moduledoc """
  Get é um módulo do tipo facade com o intuito de apresentar
  uma interface mais simplificada para list um usuarios.
  """
  alias Stonex.User
  alias Stonex.Repo

  def call(id) do
    id
    |> get()
  end

  defp get(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User not found"}
      user -> {:ok, Repo.preload(user, :account)}
    end
  end
end
