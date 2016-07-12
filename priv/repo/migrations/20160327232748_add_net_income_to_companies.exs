defmodule Dez.Repo.Migrations.AddNetIncomeToCompanies do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :net_income, :bigint
      add :pe10, :numeric
      remove :pe
    end
  end
end
