defmodule Scraper do
  def scrape do
    for exchange <- exchanges do
      get_companies_from_stock_exchange(exchange)
    end
  end

  def add(companies) do
    coordinator_pid = spawn(Dez.Coordinator, :loop, [[], Enum.count(companies)])

    companies
    |> Enum.each(fn company ->
      worker_pid = spawn(MarketCap, :loop, [])
      send worker_pid, {coordinator_pid, company}
    end)
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

  defp exchanges do
    [{:NASDAQ, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download"},
     {:AMEX, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download"},
     {:NYSE, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download"}]
  end
end
