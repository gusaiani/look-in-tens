defmodule Dez.Scraper.MarketCap do
  alias Dez.{NumberHelper}

  def loop do
    receive do
      {sender_pid, company} ->
        ticker = Enum.at(company, 0)
        send(sender_pid, {:ok, company, fetch(ticker)})
    end
    loop
  end

  def fetch(ticker) do
    case ticker |> url |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect "Found market cap url for #{ticker}."
        parse(body)
        |> NumberHelper.parse
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Market cap url for #{ticker} not found."
      {:ok, %HTTPoison.Response{status_code: 999}} ->
        IO.puts "#{ticker} took a 999 error."
        :error
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        :error
    end
  end

  defp parse(body) do
    {:ok, table} = body
      |> ExCsv.parse(headings: false)

    hd(hd(table.body))
  end

  defp url(ticker) do
    "http://download.finance.yahoo.com/d/quotes.csv?s=#{ticker}&f=j1"
  end
end
