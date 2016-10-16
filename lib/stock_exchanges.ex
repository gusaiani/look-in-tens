defmodule Dez.Scraper.StockExchanges do
  @moduledoc """
  Builds urls for stock exchanges.
  """

  @exchanges ["NASDAQ", "AMEX", "NYSE"]

  def urls do
    @exchanges
    |> Enum.shuffle
    |> Enum.map(&url/1)
  end

  def url(exchange) do
    "http://www.nasdaq.com/screening/companies-by-industry.aspx?exchange=#{exchange}&render=download"
  end
end
