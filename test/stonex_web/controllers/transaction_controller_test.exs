defmodule StonexWeb.Controllers.TransactionControllerTest do
  @moduledoc false

  use StonexWeb.ConnCase, async: true

  alias StonexWeb.Auth.Guardian

  import Stonex.Factory

  setup %{conn: conn} do
    user_1 = insert(:user)
    user_2 = insert(:user)
    account_1 = insert(:account, user_id: user_1.id)
    account_2 = insert(:account, user_id: user_2.id)

    {:ok, token, _} = Guardian.encode_and_sign(user_1)

    authenticated_conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "bearer: " <> token)

    %{
      factories: %{user_1: user_1, user_2: user_2, account_1: account_1, account_2: account_2},
      conn: authenticated_conn
    }
  end

  describe "transfer/2" do
    test "do a transfer to an account and receives an successfully message", %{
      factories: %{
        account_2: beneficiary_account,
        user_2: beneficiary_user
      },
      conn: conn
    } do
      params = %{
        account: %{
          branch: beneficiary_account.branch,
          number: beneficiary_account.number,
          digit: beneficiary_account.digit
        },
        document: beneficiary_user.document,
        value: "100.00",
        description: "Test transfer"
      }

      assert %{"message" => message} =
               conn
               |> post(Routes.transaction_path(conn, :transfer, params))
               |> json_response(:ok)

      assert message == "Transfer done successfully!"
    end

    test "do a transfer to an account with missing params and receives an error message", %{
      factories: %{
        account_2: beneficiary_account,
        user_2: beneficiary_user
      },
      conn: conn
    } do
      params = %{
        account: %{
          branch: beneficiary_account.branch,
          number: beneficiary_account.number
        },
        document: beneficiary_user.document,
        value: "100.00",
        description: "Test transfer"
      }

      assert %{"error" => %{"details" => message}} =
               conn
               |> post(Routes.transaction_path(conn, :transfer, params))
               |> json_response(:bad_request)

      assert message == "Beneficiary account has missing data"
    end
  end

  describe "transaction/2" do
    test "do a withdraw and receives an successfully message", %{
      conn: conn,
      factories: %{user_1: requester_user}
    } do
      requester_email = requester_user.email

      params = %{
        value: "100.00"
      }

      assert %{"message" => message} =
               conn
               |> post(Routes.transaction_path(conn, :withdraw, params))
               |> json_response(:ok)

      assert message ==
               "Withdraw done successfully. Receipt of withdrawal sent to email: #{requester_email} "
    end
  end
end
