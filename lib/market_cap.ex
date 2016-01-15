defmodule MarketCap do
  def scrape(ticker) do
    url = "http://download.finance.yahoo.com/d/quotes.csv?s=#{ticker}&f=j1"

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
      |> ExCsv.parse(headings: false)

    result = table.body

    hd(hd(result))
  end
end
