defmodule Stonex.AccountsTest do
  @moduledoc false

  use ExUnit.Case
  use Stonex.DataCase

  import Stonex.Factory

  alias Stonex.Accounts
  alias Stonex.Accounts.Account

  describe "list_accounts" do
    test "expects returns a list of accounts in case of there are accounts created" do
      user_1 = insert(:user)
      user_2 = insert(:user)

      account_1 = insert(:account, %{user_id: user_1.id})
      account_2 = insert(:account, %{user_id: user_2.id})

      assert [retrieved_account_1, retrieved_account_2] = Accounts.list_accounts()

      assert retrieved_account_1.id == account_1.id
      assert retrieved_account_2.id == account_2.id
    end

    test "expects return a empty list in case of there is not accounts created" do
      assert [] = Accounts.list_accounts()
    end
  end

  describe "get_account_by_id/1" do
    setup do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id})

      %{account: account}
    end

    test "expects returns a {:ok, %Account{}} when pass valid account id", %{account: account} do
      assert {:ok, retrieved_account} = Accounts.get_account_by_id(account.id)

      assert retrieved_account.id == account.id
    end

    test "expects returns a {:error, 'Account not found'} when pass an invalid account id" do
      assert {:error, message} = Accounts.get_account_by_id(Ecto.UUID.generate())

      assert message == "Account not found"
    end
  end

  describe "create_account/1" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "expects returns a {:ok, account} when pass a valid map attributes", %{
      user: %Stonex.User{id: user_id}
    } do
      assert {:ok, %Account{} = account} = Accounts.create_account(%{user_id: user_id})

      assert account.user_id == user_id
    end

    test "expects returns a {:error, changeset} when pass a invalid map attributes" do
      assert {:error, changeset} = Accounts.create_account(%{user_id: "123"})

      assert changeset.valid? == false
    end
  end

  describe "update_account/2" do
    setup do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id})

      %{account: account}
    end

    test "expects retursn {:ok, %Account{}} after updates an account", %{account: account} do
      assert {:ok, updated_account} =
               Accounts.update_account(account, %{balance: Decimal.new(1500)})

      assert Decimal.equal?(updated_account.balance, 1500) == true
    end
  end

  describe "delete_account/1" do
    setup do
      user = insert(:user)
      account = insert(:account, %{user_id: user.id})

      %{account: account}
    end

    test "expects returns a {:ok, %Account{}} when pass a valid account struct ", %{
      account: account
    } do
      assert {:ok, deleted_account} = Accounts.delete_account(account)

      assert deleted_account.id == account.id
    end
  end
end
