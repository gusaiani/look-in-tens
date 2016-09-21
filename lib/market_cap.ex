defmodule Dez.Scraper.MarketCap do
  alias Dez.Scraper.MarketCap.{YahooFinance, Bloomberg}

  @sourceModules [YahooFinance, Bloomberg]

  def loop do
    receive do
      {coordinator_pid, company, :not_available, dataSourcePosition} ->
        IO.inspect "Failed getting valid market cap from source. Trying another source."
        fetch(self(), coordinator_pid, company, dataSourcePosition + 1)
      {coordinator_pid, company, result, _} ->
        IO.inspect "Successful Market Cap Result"
        IO.inspect result
        send(coordinator_pid, {:ok, company, result})
      {coordinator_pid, company} ->
        fetch(self(), coordinator_pid, company)
    end
    loop
  end

  def fetch(market_cap_pid, coordinator_pid, company, dataSourcePosition \\ 0) do
    ticker = company |> Enum.at(0)
    module = @sourceModules |> Enum.at(dataSourcePosition)

    send(market_cap_pid,
        {coordinator_pid, company, apply(module, :start, [market_cap_pid, ticker]), dataSourcePosition})
  end
end
