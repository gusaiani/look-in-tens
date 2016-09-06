defmodule Dez.Scraper.MarketCap do
  alias Dez.{NumberHelper, Scraper.NetIncome}

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
        parse(body)
        |> NumberHelper.parse
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "#{ticker} market cap not found"
      {:ok, %HTTPoison.Response{status_code: 999}} ->
        IO.puts "#{ticker} took a 999 error"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
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
