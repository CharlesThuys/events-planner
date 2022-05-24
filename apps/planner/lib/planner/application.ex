defmodule Planner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Planner.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Planner.PubSub}
      # Start a worker by calling: Planner.Worker.start_link(arg)
      # {Planner.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Planner.Supervisor)
  end
end
