defmodule :"Elixir.Dez.Repo.Migrations.Add-ticker-pe-to-company" do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :market_cap, :string
    end

    create index(:companies, [:market_cap])
  end
end
