defmodule StonexWeb.TransactionView do
  use StonexWeb, :view

  def render("success.json", %{message: message}) do
    %{
      message: message
    }
  end
end
