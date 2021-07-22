defmodule StonexWeb.ErrorView do
  use StonexWeb, :view

  def render("error.json", %{changeset: %Ecto.Changeset{} = changeset}) do
    %{
      error: %{
        details: translate_errors(changeset)
      }
    }
  end

  def render("error.json", %{reason: message}) do
    IO.inspect(message)

    %{
      error: %{
        details: message
      }
    }
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
