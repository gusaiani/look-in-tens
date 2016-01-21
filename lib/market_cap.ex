defmodule MarketCap do
  def loop do
    receive do
      {sender_pid, company} ->
        ticker = Enum.at(company, 0)
        send(sender_pid, {:ok, company, scrape(ticker)})
      # _ ->
      #   send(_, "Unknown message")
    end
    loop
  end

  def scrape(ticker) do
    url = "http://download.finance.yahoo.com/d/quotes.csv?s=#{ticker}&f=j1"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse(body)
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
