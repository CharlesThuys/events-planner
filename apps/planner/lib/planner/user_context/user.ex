defmodule Planner.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Planner.EventContext.Event
  alias Planner.UserContext.Follow
  alias Planner.ApiContext.Key

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :image, :string, default: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"
    field :role, :string
    field :username, :string
    has_many :events, Event, foreign_key: :user_id
    has_many :keys, Key, foreign_key: :user_id
    many_to_many :invites, Event, join_through: "invites"
    many_to_many :follow, Follow, join_through: "follows"
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :image])
    |> validate_required([:username, :password, :image])
    |> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint(:username)
    |> put_password_hash()
    |> put_user_role()
  end

  def changeset_admin(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role, :image])
    |> validate_required([:username, :password, :role, :image])
    |> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  def changeset_admin_edit(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role, :image])
    |> validate_required([:username, :role, :image])
    |> validate_inclusion(:role, @acceptable_roles)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  def changeset_password(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  def changeset_image(user, attrs) do
    user
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset


  defp put_user_role(%Ecto.Changeset{} = changeset) do
    change(changeset, role: "User")
  end

  
  defp put_user_role(changeset), do: changeset

end
