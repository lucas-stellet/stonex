defmodule Stonex.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table :transactions, primary_key: false do
      add :id, :uuid, primary_key: true
      add :status,:string
      add :type,:string
      add :value, :decimal, precision: 16, scale: 2
      add :beneficiary_id, :uuid
      add :requester_id, :uuid
      add :description, :string
      add :observation, :string

      timestamps(updated_at: false)
    end
  end
end
