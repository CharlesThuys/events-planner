defmodule Planner.UserContext.Follow do
    use Ecto.Schema
    import Ecto.Changeset
  
  
    schema "follows" do
      field :user_id, :integer
      field :following_id, :integer
    end
  
    @doc false
    def changeset(follow, attrs) do
      follow
      |> cast(attrs, [:user_id, :following_id])
      |> validate_required([:user_id, :following_id])
    end
  end