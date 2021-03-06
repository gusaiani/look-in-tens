defmodule Dez.Scraper do
  @moduledoc """
  Main scraper module, starts everything.
  """

  use GenServer

  alias Dez.Scraper.{StockExchanges, MarketCapCoordinator, NetIncomeCoordinator}

  @market_cap_minutes 15
  @net_income_minutes 240

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    if Mix.env == :dev, do: :observer.start

    # if Mix.env == :prod do
      :timer.send_after(1, :do_market_caps)
      :timer.send_after(5_000, :do_net_incomes)
      :timer.send_interval(@market_cap_minutes * 60 * 1000, :do_market_caps)
      :timer.send_interval(@net_income_minutes * 60 * 1000, :do_net_incomes)
    # end

    {:ok, state}
  end

  def handle_info(:do_market_caps, state) do
    do_start(MarketCapCoordinator)
    {:noreply, state}
  end

  def handle_info(:do_net_incomes, state) do
    do_start(NetIncomeCoordinator)
    {:noreply, state}
  end

  def do_start(module) do
    for url <- StockExchanges.urls, do: get_companies(url, module)
  end

  defp get_companies(url, module) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: companies}} ->
        company_list = companies |> parse_list
        apply(module, :start, [company_list])

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

  defp add(companies) do
    MarketCapCoordinator.start(companies)
    NetIncomeCoordinator.start(companies)
  end
end
