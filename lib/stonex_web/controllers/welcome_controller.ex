defmodule StonexWeb.WelcomeController do
  use StonexWeb, :controller

  def hello(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{"message" => "Welcome to Stonex API!"})
  end
end
