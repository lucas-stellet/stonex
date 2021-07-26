defmodule StonexWeb.FallbackController do
  @moduledoc """
  Handle errors in the StonexWeb application
  """

  use StonexWeb, :controller

  alias StonexWeb.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, %Ecto.Changeset{} = changeset) do
    call(conn, {:error, changeset})
  end

  def call(conn, nil) do
    call(conn, {:error, :not_found})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("error.json", reason: gettext("Incorrect document or password"))
  end

  def call(conn, {:error, reason}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("error.json", reason: reason)
  end
end
