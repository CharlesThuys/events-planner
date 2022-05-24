defmodule Planner.ApiContext do

  import Ecto.Query, warn: false
  alias Planner.Repo

  alias Planner.UserContext.User
  alias Planner.ApiContext.Key

  defp randstr do
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    |> String.codepoints
    |> Enum.take_random(30)
    |> Enum.join
  end

  def generateKey(user) do
    new_key = randstr()
    create_key(%{"key" => new_key}, user)
  end

  def list_keys do
    Repo.all(Key)
  end

  def my_keys(user_id) do
    Repo.all(
      from k in "keys",
      where: k.user_id == ^user_id,
      select: %{
        key: k.key
      }
    )
  end

  def get_api_key(key) do
    if is_nil(key) do
      nil
    else
      Repo.get_by(Key, key: key)
    end
  end

  def get_key!(id), do: Repo.get!(Key, id)

  def create_key(attrs,  %User{} = user) do
    %Key{}
    |> Key.changeset(attrs, user)
    |> Repo.insert()
  end

  def update_key(%Key{} = key, attrs) do
    key
    |> Key.changeset(attrs)
    |> Repo.update()
  end

  def delete_key(%Key{} = key) do
    Repo.delete(key)
  end

  def change_key(%Key{} = key, attrs \\ %{}) do
    Key.changeset(key, attrs)
  end
end