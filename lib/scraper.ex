defmodule Scraper do
  alias Dez.{Company, Repo}

  def scrape do
    for exchange <- exchanges do
      get_companies_from_stock_exchange(exchange)
    end
  end

  defp get_companies_from_stock_exchange({_exchange, url}) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        import_companies(companies)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def import_companies(companies) do
    companies
    |> parse_list
    |> add
  end

  defp parse_list(companies) do
    {:ok, table} = companies |> ExCsv.parse(headings: true)
    table.body
  end

  defp add([]) do
    IO.puts "Stock exchange scrape finished."
  end

  defp add([company|tail]) do
    ticker = Enum.at(company, 0)
    market_cap = MarketCap.scrape(ticker)

    case market_cap do
      {:ok, market_cap} -> save(company, market_cap)
    end

    add tail
  end

  defp save(company, market_cap) do
    IO.inspect(company)
    name   = Enum.at(company, 1)
    ticker = Enum.at(company, 0)
    pe     = Float.floor(:random.uniform * 20, 2)

    changeset = Company.changeset(%Company{}, %{
      "name" => name,
      "ticker" => ticker,
      "pe" => pe,
      "market_cap" => market_cap})

      case Repo.insert(changeset) do
        {:ok, _company} ->
          IO.puts "New company added: #{name}"
        {:error, _changeset} ->
          IO.inspect "Error saving #{name} to database."
      end
  end

  defp exchanges do
    [{:NASDAQ, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download"},
     {:AMEX, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download"},
     {:NYSE, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download"}]
  end
end
