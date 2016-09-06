defmodule Scraper do
  def scrape_one_company do
    {_, url} = Enum.random(exchanges)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        company = companies |> parse_list |> Enum.random
        add([company])
    end
  end

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
        IO.puts "Stock exchange data not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts "Error retrieving stock exchange data:"
        IO.inspect reason
    end
  end

  defp import_companies(companies) do
    companies
    |> parse_list
    |> add
  end

  defp parse_list(companies) do
    {:ok, table} = companies |> ExCsv.parse(headings: true)
    table.body
  end

  defp add(companies) do
    company_count = Enum.count(companies)

    market_cap_coordinator_pid = spawn(Dez.Scraper.MarketCapCoordinator, :loop, [[], company_count])
    net_income_coordinator_pid = spawn(Dez.Scraper.NetIncomeCoordinator, :loop, [[], company_count])

    companies
    |> Enum.each(fn company ->
      market_cap_worker_pid = spawn(Dez.Scraper.MarketCap, :loop, [])
      send market_cap_worker_pid, {market_cap_coordinator_pid, company}

      net_income_worker_pid = spawn(Dez.Scraper.NetIncome, :loop, [])
      send net_income_worker_pid, {net_income_coordinator_pid, company}
    end)
  end

  defp exchanges do
    [{:NASDAQ, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download"},
     {:AMEX, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download"},
     {:NYSE, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download"}]
  end
end
