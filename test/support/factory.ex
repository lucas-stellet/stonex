defmodule Stonex.Factory do
  @moduledoc """
  Factory module to help create objects on tests.
  """
  use ExMachina.Ecto, repo: Stonex.Repo

  alias Stonex.Accounts.Account
  alias Stonex.Users.User

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
      first_name: Faker.Person.first_name(),
      last_name: Faker.Person.last_name(),
      email: Faker.Internet.email(),
      password: Faker.Util.format("%2a%2A%4d"),
      document: Faker.Util.format("%3d.%3d.%3d-%2d")
    }
  end
end
