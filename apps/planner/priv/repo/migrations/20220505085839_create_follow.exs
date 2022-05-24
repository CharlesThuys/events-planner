defmodule Planner.Repo.Migrations.CreateFollow do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :user_id, references(:users)
      add :following_id, references(:users)
    end

  create unique_index(:follows, [:user_id, :following_id])
  end
end
