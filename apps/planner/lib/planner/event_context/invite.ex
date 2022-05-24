defmodule Planner.EventContext.Invite do
    use Ecto.Schema
    import Ecto.Changeset
  
    alias Planner.UserContext.User
    alias Planner.EventContext.Event
  
    @acceptable_states [0, 1, 2]

    schema "invites" do
      belongs_to :event, Event
      belongs_to :user, User
      field :accepted, :integer, default: 0
    end
  
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:event_id, :user_id, :accepted])
        |> validate_required([:event_id, :user_id])
        |> unique_constraint(:invite_index, name: :invites_event_id_user_id_index)
        |> validate_inclusion(:accepted, @acceptable_states)
    end
  end
  