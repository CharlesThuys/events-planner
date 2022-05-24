defmodule Planner.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :date, :date
      add :time, :time
      add :description, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:events, [:user_id])
  end
end
