defmodule StonexWeb.Auth.ErrorHandler do
  @moduledoc """
  Error Handler for V1 Auth
  """

  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, :unauthorized, body)
  end
end
