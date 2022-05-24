defmodule Planner.ApiContext.Key do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Planner.UserContext.User

  schema "keys" do
    field :key, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:key])
    |> validate_required([:key])
  end

  def changeset(key, attrs, user) do
    key
    |> cast(attrs, [:key])
    |> validate_required([:key])
    |> put_assoc(:user, user)
  end
end