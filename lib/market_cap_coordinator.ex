defmodule Dez.Scraper.MarketCapCoordinator do
  alias Dez.{Company, Repo}
  import Ecto.Query

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, company, market_cap} ->
        new_results = [market_cap|results]

        ticker = List.first(company)

        save(company, market_cap)

        if results_expected == Enum.count(new_results) do
          send self, :exit
        end

        loop(new_results, results_expected)

      :exit ->
        IO.puts "Scrape finished"

      _ ->
        loop(results, results_expected)
    end
  end

  defp save(company, :error) do
    name = Enum.at(company, 1)
    IO.inspect "Skipping save on #{name} market cap due to scrape error."
  end

  defp save(company, market_cap) do
    name = Enum.at(company, 1)
    ticker = Enum.at(company, 0)

    new_company = %{
      "name" => name,
      "ticker" => ticker,
      "market_cap" => market_cap}

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
    changeset = Company.changeset(company, changes)

    case Repo.update(changeset) do
        {:ok, _} ->
          IO.puts "Company updated: #{changes["name"]}"
          changes["ticker"]
        {:error, changeset} ->
          IO.inspect "Error updating #{changes["name"]}"
          IO.inspect changeset.errors
          :error
    end
  end
end
