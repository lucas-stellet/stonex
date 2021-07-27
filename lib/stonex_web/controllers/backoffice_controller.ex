defmodule StonexWeb.BackofficeController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  def create(conn, params) do
    with {:ok, user} <- Stonex.create_user(Map.put(params, "role", "admin")) do
      conn
      |> put_status(:created)
      |> render("create.json", %{user: user})
    end
  end

  def reports(conn, %{"type" => "range", "from" => from, "to" => to}) do
    with {:ok, report} <- Stonex.get_reports(%{type: "range", from: from, to: to}) do
      conn
      |> put_status(:ok)
      |> render("report.json", %{report: report})
    end
  end

  def reports(conn, %{"type" => type}) do
    with {:ok, report} <- Stonex.get_reports(%{type: type, from: nil, to: nil}) do
      conn
      |> put_status(:ok)
      |> render("report.json", %{report: report})
    end
  end
end
