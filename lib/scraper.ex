defmodule Scraper do
  alias Dez.Company
  alias Dez.Repo

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

  defp add([head|tail]) do
    name   = Enum.at(head, 1)
    ticker = Enum.at(head, 0)
    pe = Float.floor(:random.uniform * 20, 2)

    changeset = Company.changeset(%Company{}, %{"name" => name, "ticker" => ticker, "pe" => pe})

    if changeset.valid? do
      Repo.insert!(changeset)
      IO.puts "New company added: #{name}!"
    end

    add tail
  end

  defp exchanges do
    [{:NASDAQ, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NASDAQ&render=download"},
     {:AMEX, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=AMEX&render=download"},
     {:NYSE, "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=NYSE&render=download"}]
  end
end
