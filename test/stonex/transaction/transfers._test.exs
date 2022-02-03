defmodule Stonex.Transactions.TransfersTest do
  @moduledoc false

  use ExUnit.Case
  use Stonex.DataCase

  setup do
    user1 = insert(:user)
    user2 = insert(:user)

    account1 = insert(:account, user: user1)
    account2 = insert(:account, user: user2)

    %{user_1: user1, user_2: user2, account_1: account1, account_2: account2}
  end

  describe "create_transfer/1" do
    test "returns {:ok, 'Transfer done successfully!'} when pass valid params", %{user_1: requester, user_2: beneficiary, account_1: requester_account, account_2: benefiaciary_account} do
      %{
        "account" =>  %{
            "branch" =>  "0001",
            "number" =>  "616462",
            "digit"+> "8"
        },
        "document" => "005.006.007-08",
        "value" => "100.00",
      }

    end
  end

  defp create_requester_info do

  end
end
