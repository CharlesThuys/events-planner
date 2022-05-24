defmodule Planner.EventContext.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Planner.UserContext.User
  alias Planner.EventContext.Invite

  schema "events" do
    field :date, :date
    field :description, :string
    field :image, :string, default: "https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg?cs=srgb&dl=pexels-wendy-wei-1190298.jpg&fm=jpg"
    field :name, :string
    field :time, :time
    belongs_to :user, User
    many_to_many :invited, User, join_through: "invites" 
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :date, :time, :description, :image])
    |> validate_required([:name, :date, :time, :description, :image])
  end

  @doc false
  def changeset(event, attrs, user) do
    event
    |> cast(attrs, [:name, :date, :time, :description, :image])
    |> validate_required([:name, :date, :time, :description, :image])
    |> put_assoc(:user, user)
  end

end
