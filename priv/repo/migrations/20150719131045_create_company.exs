defmodule Dez.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string

      timestamps
    end

  end
end
