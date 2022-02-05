defmodule StonexWeb.BackofficeController do
  use StonexWeb, :controller

  action_fallback StonexWeb.FallbackController

  alias Stonex.Backoffice.Reports
  alias Stonex.Users

  def create(conn, params) do
    with {:ok, user} <- Users.create_user(Map.put(params, "role", "admin")) do
      conn
      |> put_status(:created)
      |> render("create.json", %{user: user})
    end
  end

  def reports(conn, %{"type" => "range", "from" => from, "to" => to}) do
    with {:ok, report} <- Reports.create(%{type: "range", from: from, to: to}) do
      conn
      |> put_status(:ok)
      |> render("report.json", %{report: report})
    end
  end

  def reports(conn, %{"type" => "range"}) do
    conn
    |> put_status(400)
    |> render("error_report.json", %{reason: "Missing 'from' and 'to' params."})
  end

  def reports(conn, %{"type" => type}) do
    with {:ok, report} <- Reports.create(%{type: type, from: nil, to: nil}) do
      conn
      |> put_status(:ok)
      |> render("report.json", %{report: report})
    end
  end
end
