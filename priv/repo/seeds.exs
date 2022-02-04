alias Stonex.Transactions.Transaction
alias Stonex.Repo

# Create Tony Stasl user and his back accoun

{:ok, %{id: tony_stark_id}} =
  Stonex.Users.create_user(%{
    "first_name" => "Tony",
    "last_name" => "Stark",
    "email" => "iron_man@gmail.com",
    "password" => "10203040",
    "document" => "001.002.003-04"
  })

{:ok, %{id: tony_stark_account_id}} = Stonex.Accounts.create_account(%{user_id: tony_stark_id})

# Create Peter Parker user and his back account

{:ok, %{id: peter_parker_id}} =
  Stonex.Users.create_user(%{
    "first_name" => "Peter",
    "last_name" => "Parker",
    "email" => "spider-Man@gmail.com",
    "password" => "50607080",
    "document" => "005.006.007-08"
  })

{:ok, %{id: peter_parker_account_id}} =
  Stonex.Accounts.create_account(%{user_id: peter_parker_id})

# Create Nick Fury backoffice user

Stonex.Users.create_user(%{
  "first_name" => "Nick",
  "last_name" => "Fury",
  "email" => "nick@shield.com",
  "password" => "00102000",
  "document" => "000.001.002-00",
  "role" => "admin"
})
