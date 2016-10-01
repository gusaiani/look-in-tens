defmodule Dez.Scraper.MarketCap do
  alias Dez.Scraper.MarketCap.{YahooFinance, Bloomberg}

  @source_modules [YahooFinance, Bloomberg]

  def loop do
    receive do
      {coordinator_pid, company, :not_found} ->
        IO.inspect "Failed getting valid market cap from all sources."
        send(coordinator_pid, {:ok, company, :not_found})
      {coordinator_pid, company, :not_available, dataSourcePosition} ->
        IO.inspect "Failed getting valid market cap from source. Trying another source."
        fetch(self(), coordinator_pid, company, dataSourcePosition + 1)
      {coordinator_pid, company, :error, dataSourcePosition} ->
        IO.inspect "Errored getting valid market cap from source. Trying another source."
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

  def fetch(market_cap_pid, coordinator_pid, company, dataSourcePosition \\ 0)

  def fetch(market_cap_pid, coordinator_pid, company, dataSourcePosition)
  when dataSourcePosition == length(@source_modules)  do
    send(market_cap_pid, {coordinator_pid, company, :not_found})
  end


  def fetch(market_cap_pid, coordinator_pid, company, dataSourcePosition) do
    ticker = company |> Enum.at(0)
    module = @source_modules |> Enum.at(dataSourcePosition)

    send(market_cap_pid,
        {coordinator_pid, company, apply(module, :start, [market_cap_pid, ticker]), dataSourcePosition})
  end
end
