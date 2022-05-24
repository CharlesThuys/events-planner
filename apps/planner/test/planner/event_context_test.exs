defmodule Planner.EventContextTest do
  use Planner.DataCase

  alias Planner.EventContext

  describe "events" do
    alias Planner.EventContext.Event

    import Planner.EventContextFixtures

    @invalid_attrs %{date: nil, description: nil, image: nil, name: nil, time: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert EventContext.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert EventContext.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{date: ~D[2022-04-26], description: "some description", image: "some image", name: "some name", time: ~T[14:00:00]}

      assert {:ok, %Event{} = event} = EventContext.create_event(valid_attrs)
      assert event.date == ~D[2022-04-26]
      assert event.description == "some description"
      assert event.image == "some image"
      assert event.name == "some name"
      assert event.time == ~T[14:00:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventContext.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{date: ~D[2022-04-27], description: "some updated description", image: "some updated image", name: "some updated name", time: ~T[15:01:01]}

      assert {:ok, %Event{} = event} = EventContext.update_event(event, update_attrs)
      assert event.date == ~D[2022-04-27]
      assert event.description == "some updated description"
      assert event.image == "some updated image"
      assert event.name == "some updated name"
      assert event.time == ~T[15:01:01]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = EventContext.update_event(event, @invalid_attrs)
      assert event == EventContext.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = EventContext.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> EventContext.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = EventContext.change_event(event)
    end
  end

  describe "invites" do
    alias Planner.EventContext.Invite

    import Planner.EventContextFixtures

    @invalid_attrs %{}

    test "list_invites/0 returns all invites" do
      invite = invite_fixture()
      assert EventContext.list_invites() == [invite]
    end

    test "get_invite!/1 returns the invite with given id" do
      invite = invite_fixture()
      assert EventContext.get_invite!(invite.id) == invite
    end

    test "create_invite/1 with valid data creates a invite" do
      valid_attrs = %{}

      assert {:ok, %Invite{} = invite} = EventContext.create_invite(valid_attrs)
    end

    test "create_invite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventContext.create_invite(@invalid_attrs)
    end

    test "update_invite/2 with valid data updates the invite" do
      invite = invite_fixture()
      update_attrs = %{}

      assert {:ok, %Invite{} = invite} = EventContext.update_invite(invite, update_attrs)
    end

    test "update_invite/2 with invalid data returns error changeset" do
      invite = invite_fixture()
      assert {:error, %Ecto.Changeset{}} = EventContext.update_invite(invite, @invalid_attrs)
      assert invite == EventContext.get_invite!(invite.id)
    end

    test "delete_invite/1 deletes the invite" do
      invite = invite_fixture()
      assert {:ok, %Invite{}} = EventContext.delete_invite(invite)
      assert_raise Ecto.NoResultsError, fn -> EventContext.get_invite!(invite.id) end
    end

    test "change_invite/1 returns a invite changeset" do
      invite = invite_fixture()
      assert %Ecto.Changeset{} = EventContext.change_invite(invite)
    end
  end
end
