defmodule Scraper do
  alias Dez.Scraper.{StockExchanges, MarketCapCoordinator, NetIncomeCoordinator}

  def company do
    add([["AAPL", "Apple"]])
  end

  def company(company) when is_list(company) do
    add([company])
  end

  def company(company) when is_binary(company) do
    add([[company, company]])
  end

  def random() do
    url = StockExchanges.urls |> Enum.random

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        company = companies |> parse_list |> Enum.random |> IO.inspect

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
