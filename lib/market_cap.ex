defmodule MarketCap do
  def scrape(ticker) do
    url = "http://download.finance.yahoo.com/d/quotes.csv?s=#{ticker}&f=j1"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        result = parse(body)
        {:ok, result}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "#{ticker} market cap not found"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp parse(body) do
    {:ok, table} = body
      |> ExCsv.parse(headings: false)
    hd(hd(table.body))
  end
end
