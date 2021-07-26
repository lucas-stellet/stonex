defmodule StonexWeb.AuthView do
  use StonexWeb, :view

  def render("login.json", %{token: token}) do
    %{
      token: token
    }
  end
end
