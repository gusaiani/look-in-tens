defmodule Dez.Scraper.NetIncomeCoordinator do
  alias Dez.{Company, Repo, PE10}
  import Ecto.Query

  def start(companies) do
    company_count = Enum.count(companies)

    coordinator_pid = spawn(__MODULE__, :loop, [[], company_count])

    companies
    |> Enum.each(fn company ->
      worker_pid = spawn(Dez.Scraper.NetIncome, :loop, [])
      send worker_pid, {coordinator_pid, company}
    end)

  end

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

  defp save(company, :error) do
    name = Enum.at(company, 1)
    IO.inspect "Skipping save on #{name} net income due to scrape error."
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

    changeset =
      company
      |> Company.changeset(changes)
      |> pe10_changeset({company.market_cap, changes["net_income"]})

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

  defp pe10_changeset(changeset, {market_cap, net_income}) do
    case PE10.calc(market_cap, net_income) do
      {:ok, pe10} -> Company.changeset(changeset, %{"pe10" => pe10})
      _ -> changeset
    end
  end
end
