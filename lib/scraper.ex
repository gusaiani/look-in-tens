defmodule Scraper do
  use Application

  def start(_type, _args) do
    Dez.Supervisor.start_link()
  end

  def start_link(backend, query, query_ref, owner, limit) do
    backend.start_link(query, query_ref, owner, limit)
  end

  def scrape do
    scrape_stock_exchange(exchanges)
  end

  defp scrape_stock_exchange([head|tail]) do
    get_companies_from_stock_exchange(head)
    scrape_stock_exchange(tail)
  end

  defp scrape_stock_exchange([]) do
    IO.puts "Exchanges scraped."
  end

  defp get_companies_from_stock_exchange({exchange, url}) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp parse(body) do
    {:ok, table} = body
      |> ExCsv.parse(headings: true)

    IO.inspect table.headings
    add table.body
  end

  defp add([]) do
    IO.puts "Stock exchange scrape finished."
  end

  alias Dez.{Company, Repo}

  defp add([company|tail]) do
    ticker = Enum.at(company, 0)
    market_cap = MarketCap.scrape(ticker)

    case market_cap do
      {:ok, market_cap} ->
        name = Enum.at(company, 1)
        pe = Float.floor(:random.uniform * 20, 2)

        changeset = Company.changeset(%Company{}, %{
          "name" => name,
          "ticker" => ticker,
          "pe" => pe,
          "market_cap" => market_cap})

          case Repo.insert(changeset) do
            {:ok, _company} ->
              IO.puts "New company added: #{name}"
            {:error, changeset} ->
              IO.inspect "Error saving #{name} to database."
          end
    end

    add tail
  end

  defp await_results(children, opts) do
    timeout = opts[:timeout] || 5000
    timer = Process.send_after(self(), :timedout, timeout)
    results = await_result(children, [], :infinity)
    cleanup(timer)
    results
  end

  defp await_result do

  end

  defp exchanges do
    [{:NASDAQ, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download"},
     {:AMEX, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download"},
     {:NYSE, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download"}]
  end
end
