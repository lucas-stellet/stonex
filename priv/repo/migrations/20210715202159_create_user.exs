defmodule Stonex.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :document, :string
      add :password_hash, :string
      add :role, :string

      timestamps()
    end

    create unique_index(:users, :email)
    create unique_index(:users, :document)
  end
end
