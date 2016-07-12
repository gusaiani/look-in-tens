defmodule Dez.Repo.Migrations.ConvertNetIncomeToFloat do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      remove :net_income
      add :net_income, :float
    end
  end
end
