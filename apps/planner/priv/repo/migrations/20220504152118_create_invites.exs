defmodule Planner.Repo.Migrations.CreateInvites do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :event_id, references(:events, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :accepted, :integer
    end

    create index(:invites, [:event_id])
    create index(:invites, [:user_id])
    create unique_index(:invites, [:event_id, :user_id])
  end
end
