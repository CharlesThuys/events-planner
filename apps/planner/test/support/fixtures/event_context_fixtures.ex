defmodule Planner.EventContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planner.EventContext` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        date: ~D[2022-04-26],
        description: "some description",
        image: "some image",
        name: "some name",
        time: ~T[14:00:00]
      })
      |> Planner.EventContext.create_event()

    event
  end

  @doc """
  Generate a invite.
  """
  def invite_fixture(attrs \\ %{}) do
    {:ok, invite} =
      attrs
      |> Enum.into(%{

      })
      |> Planner.EventContext.create_invite()

    invite
  end
end
