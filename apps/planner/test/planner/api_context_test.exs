defmodule Planner.ApiContextTest do
  use Planner.DataCase

  alias Planner.ApiContext

  describe "keys" do
    alias Planner.ApiContext.Key

    import Planner.ApiContextFixtures

    @invalid_attrs %{key: nil}

    test "list_keys/0 returns all keys" do
      key = key_fixture()
      assert ApiContext.list_keys() == [key]
    end

    test "get_key!/1 returns the key with given id" do
      key = key_fixture()
      assert ApiContext.get_key!(key.id) == key
    end

    test "create_key/1 with valid data creates a key" do
      valid_attrs = %{key: "some key"}

      assert {:ok, %Key{} = key} = ApiContext.create_key(valid_attrs)
      assert key.key == "some key"
    end

    test "create_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ApiContext.create_key(@invalid_attrs)
    end

    test "update_key/2 with valid data updates the key" do
      key = key_fixture()
      update_attrs = %{key: "some updated key"}

      assert {:ok, %Key{} = key} = ApiContext.update_key(key, update_attrs)
      assert key.key == "some updated key"
    end

    test "update_key/2 with invalid data returns error changeset" do
      key = key_fixture()
      assert {:error, %Ecto.Changeset{}} = ApiContext.update_key(key, @invalid_attrs)
      assert key == ApiContext.get_key!(key.id)
    end

    test "delete_key/1 deletes the key" do
      key = key_fixture()
      assert {:ok, %Key{}} = ApiContext.delete_key(key)
      assert_raise Ecto.NoResultsError, fn -> ApiContext.get_key!(key.id) end
    end

    test "change_key/1 returns a key changeset" do
      key = key_fixture()
      assert %Ecto.Changeset{} = ApiContext.change_key(key)
    end
  end
end
