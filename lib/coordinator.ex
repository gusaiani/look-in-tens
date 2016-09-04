defmodule Dez.Coordinator do
  alias Dez.{Company, Repo, Scraper.NetIncome}

  def loop(results \\ [], results_expected) do
    receive do
      {:ok, company, market_cap} ->
        new_results = [market_cap|results]

        ticker = List.first(company)

        save(company, market_cap)

        # worker = Task.async(NetIncome, :fetch, [ticker])
        # net_income = Task.await(worker)

        # case net_income do
        #   :error -> IO.puts "Error retrieving net income for #{ticker}"
        #   _      -> save(company, market_cap, net_income)
        # end

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

  # defp save(company, market_cap, net_income) do
  defp save(company, market_cap) do
    name = Enum.at(company, 1)
    ticker = Enum.at(company, 0)
    pe10 = "5000"

    changeset = Company.changeset(%Company{}, %{
      "name" => name,
      "ticker" => ticker,
      "pe10" => pe10,
      "market_cap" => market_cap,
      # "net_income" => net_income})
      "net_income" => "3000"})

    case Repo.insert(changeset) do
      {:ok, _company} ->
        IO.puts "New company added: #{name}"
        ticker
      {:error, _changeset} ->
        IO.inspect changeset.errors
        IO.inspect "Error saving #{name} to database."
    end
  end
end
