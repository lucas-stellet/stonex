defmodule StonexWeb.AccountView do
  use StonexWeb, :view

  def render("create.json", %{
        account: %{
          balance: balance,
          number: number,
          branch: branch,
          digit: digit,
          user: %{
            first_name: first_name,
            last_name: last_name
          }
        },
        token: token
      }) do
    %{
      message: "Account created!",
      account: %{
        number: number,
        branch: branch,
        digit: digit,
        balance: balance,
        account_owner: first_name <> " " <> last_name
      },
      token: token
    }
  end
end
