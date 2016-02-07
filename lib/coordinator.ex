defmodule Dez.Coordinator do
  alias Dez.{Company, Repo, Scraper.NetIncome}

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, company, market_cap} ->
        save(company, market_cap)
        # |> NetIncome.fetch

        new_results = [market_cap|results]

        if results_expected == Enum.count(new_results) do
          send self, :exit
        end

        loop(new_results, results_expected)
      :exit ->
        IO.puts("Scrape finished")
      _ ->
        loop(results, results_expected)
    end
  end

  defp save(company, market_cap) do
    name = Enum.at(company, 1)
    ticker = Enum.at(company, 0)
    pe = Float.floor(:random.uniform * 20, 2)

    changeset = Company.changeset(%Company{}, %{
      "name" => name,
      "ticker" => ticker,
      "pe" => pe,
      "market_cap" => market_cap})

    case Repo.insert(changeset) do
      {:ok, _company} ->
        IO.puts "New company added: #{name}"
        ticker
      {:error, _changeset} ->
        IO.inspect "Error saving #{name} to database."
    end
  end
end
