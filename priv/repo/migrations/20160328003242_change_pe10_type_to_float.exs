defmodule Dez.Repo.Migrations.ChangePe10TypeToFloat do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      remove :pe10
      add :pe10, :float
    end

  end
end
