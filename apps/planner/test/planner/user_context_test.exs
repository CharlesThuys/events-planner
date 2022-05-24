defmodule Planner.UserContextTest do
  use Planner.DataCase

  alias Planner.UserContext

  describe "users" do
    alias Planner.UserContext.User

    import Planner.UserContextFixtures

    @invalid_attrs %{hashed_password: nil, image: nil, role: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserContext.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserContext.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{hashed_password: "some hashed_password", image: "some image", role: "some role", username: "some username"}

      assert {:ok, %User{} = user} = UserContext.create_user(valid_attrs)
      assert user.hashed_password == "some hashed_password"
      assert user.image == "some image"
      assert user.role == "some role"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{hashed_password: "some updated hashed_password", image: "some updated image", role: "some updated role", username: "some updated username"}

      assert {:ok, %User{} = user} = UserContext.update_user(user, update_attrs)
      assert user.hashed_password == "some updated hashed_password"
      assert user.image == "some updated image"
      assert user.role == "some updated role"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
      assert user == UserContext.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserContext.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserContext.change_user(user)
    end
  end
end
