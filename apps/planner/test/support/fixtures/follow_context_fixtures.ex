defmodule Planner.FollowContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planner.FollowContext` context.
  """

  @doc """
  Generate a follow.
  """
  def follow_fixture(attrs \\ %{}) do
    {:ok, follow} =
      attrs
      |> Enum.into(%{

      })
      |> Planner.FollowContext.create_follow()

    follow
  end
end
