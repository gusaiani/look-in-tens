defmodule :"Elixir.Dez.Repo.Migrations.Add-ticker-pe-to-company" do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :ticker, :string
      add :pe, :float
    end

    create index(:companies, [:name, :ticker])
  end
end
