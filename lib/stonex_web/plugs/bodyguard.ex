defmodule StonexWeb.BodyGuard do
  @moduledoc """
  Plug que verifica se o usuário tem como role admim ou não.
  """
  import Plug.Conn

  import Guardian.Plug, only: [current_resource: 1]

  def init(options), do: options

  def call(%{path_info: ["api", "backoffice", _]} = conn, _opts) do
    case user_is_admin?(current_resource(conn)) do
      true ->
        merge_conn_assigns_with_requester_user(conn)

      false ->
        response = %{"message" => "Unauthorized"}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Poison.encode!(response))
        |> halt()
    end
  end

  def call(%{path_info: ["api", "transaction", _]} = conn, _opts) do
    case user_is_admin?(current_resource(conn)) do
      false ->
        merge_conn_assigns_with_requester_user(conn)

      true ->
        response = %{"message" => "Only users with account can do transactions."}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Poison.encode!(response))
        |> halt()
    end
  end

  defp merge_conn_assigns_with_requester_user(conn) do
    {:ok, user} = current_resource(conn)

    user
    |> Stonex.Repo.preload(:account)
  end

  defp user_is_admin?({:ok, %{role: :admin}}), do: true

  defp user_is_admin?({:ok, %{role: :client}}), do: false
end
