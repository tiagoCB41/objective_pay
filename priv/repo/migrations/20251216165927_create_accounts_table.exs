defmodule ObjectivePay.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :numero_conta, :integer, null: false
      add :saldo, :decimal, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:account, [:numero_conta])
  end
end
