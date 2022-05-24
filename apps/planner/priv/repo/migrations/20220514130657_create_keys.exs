defmodule Planner.Repo.Migrations.CreateKeys do
  use Ecto.Migration

  def change do
    create table(:keys) do
      add :key, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:keys, [:user_id])
  end
end
