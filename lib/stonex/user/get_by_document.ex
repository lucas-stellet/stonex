defmodule Stonex.User.GetByDocument do
  @moduledoc """
  Get é um módulo com o intuito de apresentar
  uma interface mais simplificada para listar um usuário pelo seu `document`.
  """
  alias Stonex.User
  alias Stonex.Repo

  def call(document) do
    document
    |> get()
  end

  defp get(document) do
    case Repo.get_by(User, document: document) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end
end
