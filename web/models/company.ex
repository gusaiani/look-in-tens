defmodule Dez.Company do
  use Dez.Web, :model

  schema "companies" do
    field :name, :string
    field :ticker, :string
    field :pe, :float

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(ticker pe)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
