defmodule Planner.UserContext do
 
  import Ecto.Query, warn: false
  alias Planner.Repo

  alias Planner.UserContext.User
  alias Planner.UserContext.Follow

  defdelegate get_acceptable_roles(), to: User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_admin(attrs \\ %{}) do
    %User{}
    |> User.changeset_admin(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, current_user, attrs) do
    if current_user.id != user.id do
      {:error, :no_permission}
    else
      user
      |> User.changeset(attrs)
      |> Repo.update()
    end
  end

  def update_user_admin(%User{} = user, current_user, attrs) do
    if current_user.role != "Admin" do
      {:error, :no_permission}
    else
      user
      |> User.changeset_admin_edit(attrs)
      |> Repo.update()
    end
  end

  def delete_user(%User{} = user, current_user) do
    unless current_user.role == "Admin" or user.id == current_user.id do
      {:error, :no_permission}
    else
      Repo.delete(user)
    end
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_pass(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_image(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def update_image(%User{} = user, current_user, attrs) do
    if current_user.id != user.id do
      {:error, :no_permission}
    else
      user
      |> User.changeset_image(attrs)
      |> Repo.update()
    end
  end

  def update_pass(%User{} = user, current_user, attrs) do
    if current_user.id != user.id do
      {:error, :no_permission}
    else
      user
      |> User.changeset_password(attrs)
      |> Repo.update()
    end
  end

  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end


  # Follow deel

  def getFollowerCount(user_id) do
    Repo.one(
      from f in "follows",
      where: f.following_id == ^user_id,
      select: count("*")
    )
  end

  def getFollowingCount(user_id) do
    Repo.one(
      from f in "follows",
      where: f.user_id == ^user_id,
      select: count("*")
    )
  end

  def getFollowers(user_id) do
    Repo.all(
      from f in "follows",
      join: u in "users", on: u.id == f.user_id,
      where: f.following_id == ^user_id,
      select: %{
        id: u.id,
        username: u.username
      }
    )
  end

  def getFollowing(user_id) do
    Repo.all(
      from f in "follows",
      join: u in "users", on: u.id == f.user_id,
      where: f.user_id == ^user_id,
      select: %{
        id: u.id,
        username: u.username
      }
    )
  end

  def createFollow(current_user, user) do
    cond do
      current_user.id == user.id ->
        {:error, :self_follow}

      isFollowing(current_user.id, user.id) ->
        {:error, :already_following}

      true ->
        createFollow(%{"user_id" => current_user.id, "following_id" => user.id})
    end
  end

  def createFollow(attrs) do
    %Follow{}
    |> Follow.changeset(attrs)
    |> Repo.insert()
  end

  def unfollow(current_user, user) do
    cond do
      current_user.id == user.id ->
        {:error, :self_unfollow}

      not isFollowing(current_user.id, user.id) ->
        {:error, :not_following}

      true ->
        unfollow(findFollow(current_user.id, user.id))
    end
  end

  def unfollow(%Follow{} = follow) do
    Repo.delete(follow)
  end

  def isFollowing(user_id, following_id) do
    Repo.exists? (
      from f in "follows",
      where: f.user_id == ^user_id and f.following_id == ^following_id
    )
  end

  def findFollow(user_id, following_id) do
    Repo.one(
      from f in Follow,
      where: f.user_id == ^user_id and f.following_id == ^following_id
    )
  end
end