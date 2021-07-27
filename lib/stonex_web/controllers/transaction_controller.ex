defmodule StonexWeb.TransactionController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  def transfer(conn, params) do
    merged_params = merge_with_requester_account_data(conn, params)

    with {:ok, message} <-
           Stonex.do_transfer(merged_params) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, params) do
    merged_params = merge_with_requester_account_data(conn, params)

    with {:ok, message} <-
           Stonex.do_withdraw(merged_params) do
      conn
      |> put_status(:ok)
      |> render("success.json", message: message)
    end
  end

  defp merge_with_requester_account_data(conn, params) do
    current_resource(conn)
    |> load_account_data()
    |> merge_requester_data_with_inital_data(params)
  end

  defp load_account_data({:ok, %{id: id} = requester_data}) do
    {:ok, %{id: id, balance: balance}} = Stonex.get_account(user_id: id)

    requester_data
    |> Map.put(:account_id, id)
    |> Map.put(:balance, balance)
  end

  defp merge_requester_data_with_inital_data(
         %{
           id: id,
           balance: balance,
           account_id: account_id,
           email: email,
           document: document
         },
         initial_data
       ) do
    Map.merge(initial_data, %{
      "requester_info" => %{
        "id" => id,
        "balance" => balance,
        "account_id" => account_id,
        "email" => email,
        "document" => document
      }
    })
  end
end
