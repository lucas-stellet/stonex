defmodule Stonex.Transactions.TransfersTest do
  @moduledoc false

  use ExUnit.Case
  use Stonex.DataCase

  import Stonex.Factory

  alias Stonex.Accounts
  alias Stonex.Transactions.Transfers

  setup do
    user_1 = insert(:user)
    user_2 = insert(:user)

    %{
      user_1: user_1,
      user_2: user_2,
      account_1: insert(:account, user_id: user_1.id),
      account_2: insert(:account, user_id: user_2.id)
    }
  end

  describe "create_transfer/1" do
    setup %{user_1: user_1, user_2: user_2, account_1: account_1, account_2: account_2} = ctx do
      %{
        transfer: %{
          beneficiary_data: %{
            account_branch: account_2.branch,
            account_digit: account_2.digit,
            account_number: account_2.number,
            document: user_2.document
          },
          description: "transaction test",
          requester_data: %{
            account_balance: account_1.balance,
            account_branch: account_1.branch,
            account_digit: account_1.digit,
            account_id: account_1.id,
            account_number: account_1.number,
            document: user_1.document,
            email: user_1.email,
            id: user_1.id,
            role: user_1.role
          },
          value: "50.00"
        },
        factories: ctx
      }
    end

    test "expects {:ok, 'Transfer done successfully!'} when do a 100 reais transfer",
         %{
           transfer: transfer,
           factories: %{
             account_1: requester_account,
             account_2: beneficiary_account
           }
         } do
      updated_transfer = %{transfer | value: "100.00"}

      assert {:ok, "Transfer done successfully!"} = Transfers.do_transfer(updated_transfer)

      assert {:ok, %Accounts.Account{balance: requester_balance}} =
               Accounts.get_account_by_id(requester_account.id)

      assert {:ok, %Accounts.Account{balance: beneficiary_balance}} =
               Accounts.get_account_by_id(beneficiary_account.id)

      assert Decimal.eq?(requester_balance, "900.00")
      assert Decimal.eq?(beneficiary_balance, "1100.00")
    end

    test "expects {:error, 'Account informations are not valid!'} when do a transfer with invalid account information",
         %{
           transfer: %{beneficiary_data: beneficiary_data} = transfer
         } do
      updated_beneficiary_data = %{beneficiary_data | document: "005.006.007-08"}
      updated_transfer = %{transfer | beneficiary_data: updated_beneficiary_data}

      assert {:error, "Account informations are not valid!"} =
               Transfers.do_transfer(updated_transfer)
    end

    test "expects {:error, 'Was not possible complete your transfer. Insufficient funds'} when do a transfer with invalid account information",
         %{
           transfer: transfer
         } do
      updated_transfer = %{transfer | value: "2000.00"}

      assert {:error, "Was not possible complete your transfer. Insufficient funds!"} =
               Transfers.do_transfer(updated_transfer)
    end
  end
end
