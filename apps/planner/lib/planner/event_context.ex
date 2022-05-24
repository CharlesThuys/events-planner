defmodule Planner.EventContext do

  import Ecto.Query, warn: false
  alias Planner.Repo

  alias Planner.EventContext.Invite
  alias Planner.EventContext.Event
  alias Planner.UserContext.User

  # Event deel

  def load_events(%User{} = u), do: u |> Repo.preload([:events])

  def list_events do
    Repo.all(Event)
  end

  def get_event!(id), do: Repo.get!(Event, id)

  def create_event(attrs ,  %User{} = user) do
    %Event{}
    |> Event.changeset(attrs, user)
    |> Repo.insert()
  end

  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end

  # Invite deel

  #Get all the users invited to an event and their response to the invitation
  def getInvitedUsers(event_id) do
    Repo.all(
      from i in "invites",
      join: u in "users", on: u.id == i.user_id,
      where: i.event_id == ^event_id,
      select: %{id: u.id, username: u.username, accepted: i.accepted}
    )
  end

  # Get all the events user is invited to and his response to the invitations
  def getInvitedEvents(user_id) do
    Repo.all(
      from i in "invites",
      join: e in "events", on: e.id == i.event_id,
      where: i.user_id == ^user_id,
      select: %{
        id: e.id, 
        name: e.name,
        date: e.date,
        time: e.time,
        image: e.image, 
        invite_id: i.id, 
        accepted: i.accepted
      }
    )
  end

  def createInvitation(event, user, current_user) do
    cond do
      user == nil ->
        {:error, "User does not exist."}
   
      current_user.id != event.user_id ->
        {:error, "Not event owner."}
    
      event.user_id == user.id ->
        {:error, "Can't invite yourself."}
      
        true ->
        createInvitation(%{"user_id" => user.id, "event_id" => event.id})
    end
  end

  def createInvitation(attrs) do
    %Invite{}
    |> Invite.changeset(attrs)
    |> Repo.insert()
  end

  def respondInvitation(%Invite{} = invite, attrs) do
    if invite == nil do
      {:error, :no_invite}   
    else
      invite
      |> Invite.changeset(attrs)
      |> Repo.update()
    end
  end

  def get_invite!(id), do: Repo.get!(Invite, id)

  def isInvited(user_id, event_id) do
    Repo.exists? (
      from i in Invite,
      where: i.user_id == ^user_id and i.event_id == ^event_id
    )
  end

  def findInvite(user_id, event_id) do
    Repo.one (
      from i in Invite,
      where: i.user_id == ^user_id and i.event_id == ^event_id
    )
  end
end
