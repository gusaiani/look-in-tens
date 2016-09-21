defmodule Scraper do
  alias Dez.Scraper.{StockExchanges, MarketCapCoordinator, NetIncomeCoordinator}

  def do_one_company do
    url = StockExchanges.urls |> Enum.random

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        # company = companies |> parse_list |> Enum.random |> IO.inspect

        company = ["IGF", "iShares Global Infrastructure ETF", "40.51", "1033005000", "n/a",
                   "n/a", "n/a", "n/a", "http://www.nasdaq.com/symbol/igf", ""]
        add([company])

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect "Error scraping one company: #{reason}"
        :error
    end
  end

  def start do
    for url <- StockExchanges.urls, do: get_companies(url)
  end

  defp get_companies(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        companies
        |> parse_list
        |> add
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.inspect "Stock exchange data not found, status code #{status_code}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect "Error retrieving stock exchange data: #{reason}"
    end
  end

  defp parse_list(companies) do
    {:ok, table} = companies |> ExCsv.parse(headings: true)
    table.body
  end

  defp add(companies) do
    MarketCapCoordinator.start(companies)
    NetIncomeCoordinator.start(companies)
  end
end
