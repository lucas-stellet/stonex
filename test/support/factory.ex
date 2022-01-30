defmodule Stonex.Factory do
  use ExMachina.Ecto, repo: Stonex.Repo

  alias Stonex.Accounts.Account
  alias Stonex.User

  def account_factory do
    %Account{
      number: Integer.to_string(Enum.random(100_000..999_999)),
      branch: "0001",
      digit: Integer.to_string(Enum.random(1..9)),
      balance: 1000
    }
  end

  def user_factory do
    %User{
      first_name: "Tony",
      last_name: "Stark",
      email: "iron_man@gmail.com",
      password: "10203040",
      document: "001.002.003-04"
    }
  end
end
