defmodule Dez.Scraper.MarketCap do
  alias Dez.Scraper.MarketCap.{YahooFinance}

  def loop do
    receive do
      {sender_pid, company} ->
        ticker = Enum.at(company, 0)
        send(sender_pid, {:ok, company, YahooFinance.fetch(ticker)})
    end
    loop
  end
end
