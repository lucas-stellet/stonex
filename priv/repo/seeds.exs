alias Stonex.Transaction
alias Stonex.Repo

# Cria o usuário Tony Stark e a conta bancária

{:ok, %{id: tony_stark_id}} =
  Stonex.Users.create_user(%{
    "first_name" => "Tony",
    "last_name" => "Stark",
    "email" => "iron_man@gmail.com",
    "password" => "10203040",
    "document" => "001.002.003-04"
  })

{:ok, %{id: tony_stark_account_id}} = Stonex.Accounts.create_account(%{user_id: tony_stark_id})

# Cria o usuário Peter Park e a conta bancária

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

# Cria o usuário admin Nick fury

Stonex.Users.create_user(%{
  "first_name" => "Nick",
  "last_name" => "Fury",
  "email" => "nick@shield.com",
  "password" => "00102000",
  "document" => "000.001.002-00",
  "role" => "admin"
})

# Cria tranferências bancárias de Tony Stark para Peter Park afim de popular a tabela de transações

{:ok, t1} =
  Transaction.build(%{
    status: :done,
    type: :transfer,
    description: "nothing",
    value: 40.00,
    beneficiary_id: peter_parker_id,
    requester_id: tony_stark_id,
    observation: "done"
  })

Repo.insert!(t1)

{:ok, t2} =
  Transaction.build(%{
    status: :done,
    type: :transfer,
    description: "nothing",
    value: 30.00,
    beneficiary_id: peter_parker_id,
    requester_id: tony_stark_id,
    observation: "done"
  })

Repo.insert!(t2)

{:ok, t3} =
  Transaction.build(%{
    status: :done,
    type: :transfer,
    description: "nothing",
    value: 50.00,
    beneficiary_id: peter_parker_id,
    requester_id: tony_stark_id,
    observation: "done"
  })

Repo.insert!(t3)

{:ok, t4} =
  Transaction.build(%{
    status: :done,
    type: :transfer,
    description: "nothing",
    value: 200.00,
    beneficiary_id: peter_parker_id,
    requester_id: tony_stark_id,
    observation: "done"
  })

Repo.insert!(t4)

{:ok, t5} =
  Transaction.build(%{
    status: :done,
    type: :transfer,
    description: "nothing",
    value: 100.00,
    beneficiary_id: peter_parker_id,
    requester_id: tony_stark_id,
    observation: "done"
  })

Repo.insert!(t5)

# Atualiza as contas do Peter Parker e do Tony Stark

# tony_updated_account = Stonex.update_account(%{id: tony_stark_account_id, balance: 580.00})

# Repo.update!(tony_updated_account)

# peter_updated_account = Stonex.update_account(%{id: peter_parker_account_id, balance: 1420.00})

# Repo.update!(peter_updated_account)
