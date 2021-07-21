defmodule Stonex.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table :accounts, primary_key: false do
      add :id, :uuid, primary_key: true
      add :balance, :decimal, precision: 10, scale: 2
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :number, :string
      add :branch, :string
      add :digit, :string

      timestamps()
    end

    create unique_index(:accounts, :number)
  end
end
