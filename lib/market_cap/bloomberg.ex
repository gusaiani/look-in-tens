defmodule Dez.Scraper.MarketCap.Bloomberg do
  alias Dez.{NumberHelper}

  def start(sender_pid, ticker) do
    send(sender_pid, fetch(ticker))
  end

  def fetch(ticker) do
    # "2345"
    :not_available
    # case ticker |> url |> HTTPoison.get do
    #   {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
    #     IO.inspect "Found market cap url for #{ticker}."
    #
    #     body
    #     |> parse
    #     |> NumberHelper.parse
    #
    #   {:ok, %HTTPoison.Response{status_code: status_code}} ->
    #     IO.puts "Market cap url for #{ticker} took a #{status_code} error."
    #     :error
    #
    #   {:error, %HTTPoison.Error{reason: reason}} ->
    #     IO.inspect reason
    #     :error
    # end
  end

  # defp parse(body) do
  #   {:ok, table} =
  #     body
  #     |> ExCsv.parse(headings: false)
  #
  #   hd(hd(table.body))
  # end
  #
  # defp url(ticker) do
  #   "http://download.finance.yahoo.com/d/quotes.csv?s=#{ticker}&f=j1"
  # end
end
