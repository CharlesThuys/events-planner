defmodule Planner.ApiContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Planner.ApiContext` context.
  """

  @doc """
  Generate a key.
  """
  def key_fixture(attrs \\ %{}) do
    {:ok, key} =
      attrs
      |> Enum.into(%{
        key: "some key"
      })
      |> Planner.ApiContext.create_key()

    key
  end
end
