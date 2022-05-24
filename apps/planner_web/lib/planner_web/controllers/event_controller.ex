defmodule PlannerWeb.EventController do
  use PlannerWeb, :controller

  alias Planner.EventContext
  alias Planner.EventContext.Event
  alias Planner.UserContext
  alias PlannerWeb.Guardian
  
  def index(conn, _params) do 
    current_user = Guardian.Plug.current_resource(conn)
    events = EventContext.getInvitedEvents(current_user.id)
    render(conn, "index.html", events: events, titel: "Invited events")
  end

  def new(conn, _params) do
    changeset = EventContext.change_event(%Event{})
    render(conn, "new.html", changeset: changeset, today: Date.utc_today())
  end

  def create(conn, %{"event" => event_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    case EventContext.create_event(event_params, current_user) do
      {:ok, %Event{} = event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, today: Date.utc_today())
    end
  end

  def show(conn, %{"id" => id}) do
    event = EventContext.get_event!(id)
    user = UserContext.get_user!(event.user_id)
    invited = EventContext.getInvitedUsers(id)
    render(conn, "show.html", event: event, invited: invited, user: user)
  end

  def edit(conn, %{"id" => id}) do
    event = EventContext.get_event!(id)
    changeset = EventContext.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset, today: Date.utc_today())   
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = EventContext.get_event!(id)
    case EventContext.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset, today: Date.utc_today())
    end
  end

  def delete(conn, %{"id" => id}) do
    event = EventContext.get_event!(id)
    EventContext.delete_event(event)
    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))

  end

  def invite(conn, %{"id" => id, "invite" => invite_params}) do

    username = get_in(invite_params, ["username"])
    current_user = Guardian.Plug.current_resource(conn)
    event = EventContext.get_event!(id)
    user = UserContext.get_user_by_username(username)

    case EventContext.createInvitation(event, user, current_user) do
      {:ok, _invite} ->
        conn
        |> put_flash(:invite_info, "Invite created successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = _changeset} ->
          conn
          |> put_flash(:invite_error, "Error creating invite.")
          |> redirect(to: Routes.event_path(conn, :show, event))   

      {:error, message} ->
        conn
        |> put_flash(:invite_error, message)
        |> redirect(to: Routes.event_path(conn, :show, event))
    end  
  end
  
  def accept_invite(conn, %{"id" => id}) do

    current_user = Guardian.Plug.current_resource(conn)
    event = EventContext.get_event!(id)
    invite = EventContext.findInvite(current_user.id, event.id)

    case EventContext.respondInvitation(invite, %{"accepted" => 1}) do
      {:ok, _invite} ->
        conn
        |> put_flash(:info, "Accepted invite")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, :no_invite} ->
        conn
        |> put_flash(:error, "Not invited.")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, _params} ->
        conn
        |> redirect(to: Routes.event_path(conn, :index)) 
    end
  end

  def decline_invite(conn, %{"id" => id}) do

    current_user = Guardian.Plug.current_resource(conn)
    event = EventContext.get_event!(id)
    invite = EventContext.findInvite(current_user.id, event.id)

    case EventContext.respondInvitation(invite, %{"accepted" => 2}) do
      {:ok, _invite} ->
        conn
        |> put_flash(:info, "Declined invite")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, :no_invite} ->
        conn
        |> put_flash(:error, "Not invited.")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, _params} ->
        conn
        |> redirect(to: Routes.event_path(conn, :index))
    end
  end


  def reset_invite(conn, %{"id" => id}) do
    
    current_user = Guardian.Plug.current_resource(conn)
    event = EventContext.get_event!(id)
    invite = EventContext.findInvite(current_user.id, event.id)

    case EventContext.respondInvitation(invite, %{"accepted" => 0}) do
      {:ok, _invite} ->
        conn
        |> put_flash(:info, "Invite reset")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, :no_invite} ->
        conn
        |> put_flash(:error, "Not invited.")
        |> redirect(to: Routes.event_path(conn, :index))

      {:error, _params} ->
        conn
        |> redirect(to: Routes.event_path(conn, :index))
    end
  end

end