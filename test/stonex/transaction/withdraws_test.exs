defmodule Stonex.Transactions.WithdrawsTest do
  @moduledoc false

  use ExUnit.Case
  use Stonex.DataCase

  import Stonex.Factory

  alias Stonex.Transactions.Withdraws

  setup do
    user = insert(:user)

    %{
      user: user,
      account: insert(:account, user_id: user.id)
    }
  end

  describe "do_withdraw/1" do
    setup %{
            user: user,
            account: account
          } = ctx do
      %{
        withdraw: %{
          description: "transaction test",
          requester_data: %{
            account_balance: account.balance,
            account_branch: account.branch,
            account_digit: account.digit,
            account_id: account.id,
            account_number: account.number,
            document: user.document,
            email: user.email,
            id: user.id,
            role: user.role
          },
          value: "100.00"
        },
        factories: ctx
      }
    end

    test "expects {:ok, 'Withdraw done successfully. Receipt of withdrawal sent to email: requester_email'} when do a 100 reais withdraw",
         %{withdraw: withdraw_struct, factories: %{user: user}} do
      assert {:ok, message} = Withdraws.do_withdraw(withdraw_struct)

      assert "Withdraw done successfully. Receipt of withdrawal sent to email: #{user.email} " ==
               message
    end

    test "expects {:error, 'Was not possible complete your withdraw. Insufficient funds!'} when do a withdraw with insufficient funds",
         %{withdraw: withdraw_struct, factories: %{user: user}} do
      assert {:ok, message} = Withdraws.do_withdraw(withdraw_struct)

      assert "Withdraw done successfully. Receipt of withdrawal sent to email: #{user.email} " ==
               message
    end
  end
end
