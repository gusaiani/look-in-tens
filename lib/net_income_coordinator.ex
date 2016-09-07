defmodule Dez.Scraper.NetIncomeCoordinator do
  alias Dez.{Company, Repo}
  import Ecto.Query

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, company, net_income} ->
        new_results = [net_income|results]

        ticker = List.first(company)

        save(company, net_income)

        if results_expected == Enum.count(new_results) do
          send self, :exit
        end

        loop(new_results, results_expected)

      :exit ->
        IO.puts "Net income scrape finished"

      _ ->
        loop(results, results_expected)
    end
  end

  defp save(company, net_income) do
    name = Enum.at(company, 1)
    ticker = Enum.at(company, 0)

    new_company = %{
      "name" => name,
      "ticker" => ticker,
      "net_income" => net_income}

    query = Company |> where(ticker: ^ticker)

    case Repo.one(query) do
      nil     -> create(new_company)
      company -> edit(company, new_company)
    end
  end

  defp create(company) do
    changeset = Company.changeset(%Company{}, company)

    case Repo.insert(changeset) do
        {:ok, _} ->
          IO.puts "Company created: #{company["name"]}"
          company["ticker"]
        {:error, changeset} ->
          IO.inspect changeset.errors
          IO.inspect "Error creating #{company["name"]}"
          :error
    end
  end

  defp edit(company, changes) do
    IO.inspect changes
    IO.inspect company
    changeset = Company.changeset(company, changes)
    IO.inspect changeset

    case Repo.update(changeset) do
        {:ok, _} ->
          IO.puts "Net income updated for company: #{changes["name"]}"
          changes["ticker"]
        {:error, changeset} ->
          IO.inspect "Error updating #{changes["name"]}"
          IO.inspect changeset.errors
          :error
    end
  end
end
