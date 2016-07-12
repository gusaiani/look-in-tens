defmodule Dez.Repo.Migrations.ConvertMktCapNetIncome do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      remove :market_cap
      add :market_cap, :float
    end
  end
end
