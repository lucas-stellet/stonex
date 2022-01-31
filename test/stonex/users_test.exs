defmodule Stonex.UsersTest do
  @moduledoc false

  use ExUnit.Case
  use Stonex.DataCase

  import Stonex.Factory

  alias Stonex.Users
  alias Stonex.Users.User

  describe "list_users" do
    test "expects returns a list of users in case of there are users created" do
      user_1 = insert(:user)
      user_2 = insert(:user)

      assert [retrieved_user_1, retrieved_user_2] = Users.list_users()

      assert retrieved_user_1.id == user_1.id
      assert retrieved_user_2.id == user_2.id
    end

    test "expects return a empty list in case of there is not users created" do
      assert [] = Users.list_users()
    end
  end

  describe "get_user_by_id/1" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "expects returns a {:ok, %user{}} when pass valid user id", %{user: user} do
      assert {:ok, retrieved_user} = Users.get_user_by_id(user.id)

      assert retrieved_user.id == user.id
    end

    test "expects returns a {:error, 'user not found'} when pass an invalid user id" do
      assert {:error, message} = Users.get_user_by_id(Ecto.UUID.generate())

      assert message == "User not found"
    end
  end

  describe "get_user_by/1" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "expects returns a {:ok, %user{}} when pass valid user attributes to search", %{
      user: user
    } do
      assert {:ok, retrieved_user} =
               Users.get_user_by(%{first_name: user.first_name, document: user.document})

      assert retrieved_user.id == user.id
    end

    test "expects returns a {:error, 'user not found'} when pass an invalid user id" do
      assert {:error, message} =
               Users.get_user_by(%{first_name: "Invalid First Name", document: "Invalid Document"})

      assert message == "User not found"
    end
  end

  describe "create_user/1" do
    setup do
      %{
        user_attrs: %{
          first_name: Faker.Person.first_name(),
          last_name: Faker.Person.last_name(),
          email: Faker.Internet.email(),
          password: Faker.Util.format("%2a%2A%4d"),
          document: Faker.Util.format("%3d.%3d.%3d-%2d")
        }
      }
    end

    test "expects returns a {:ok, users} when pass a valid map attributes", %{
      user_attrs: user_attrs
    } do
      assert {:ok, %User{} = inserted_user} = Users.create_user(user_attrs)

      assert inserted_user.first_name == user_attrs.first_name
    end

    test "expects returns a {:error, changeset} when pass a invalid map attributes", %{
      user_attrs: user_attrs
    } do
      assert {:error, changeset} =
               Users.create_user(%{
                 "first_name" => user_attrs.first_name,
                 "last_name" => user_attrs.last_name
               })

      assert changeset.valid? == false
    end
  end

  describe "update_user/2" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "expects retursn {:ok, %User{}} after updates an user", %{user: user} do
      new_email = Faker.Internet.email()
      assert {:ok, updated_user} = Users.update_user(user, %{email: new_email})

      assert updated_user.email == new_email
    end
  end

  describe "delete_user/1" do
    setup do
      user = insert(:user)

      %{user: user}
    end

    test "expects returns a {:ok, %User{}} when pass a valid user struct ", %{
      user: user
    } do
      assert {:ok, deleted_user} = Users.delete_user(user)

      assert deleted_user.id == user.id
    end
  end
end
