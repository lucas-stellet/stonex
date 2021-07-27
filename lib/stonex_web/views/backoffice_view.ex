defmodule StonexWeb.BackofficeView do
  use StonexWeb, :view

  def render("create.json", _user) do
    %{
      message: "Account created!"
    }
  end

  def render("report.json", %{report: report}) do
    %{
      data: report
    }
  end

  def render("error_report.json", %{reason: reason}) do
    %{
      error: %{
        reason: reason
      }
    }
  end
end
