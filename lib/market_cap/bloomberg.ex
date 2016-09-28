defmodule Dez.Scraper.MarketCap.Bloomberg do
  alias Dez.{NumberHelper}

  def start(sender_pid, ticker) do
    send(sender_pid, fetch(ticker))
  end

  def fetch(ticker) do
    case ticker |> url |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect "Found market cap url for #{ticker}."

        body
        |> parse
        |> NumberHelper.parse

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts "Market cap url for #{ticker} took a #{status_code} error."
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        :error
    end
  end

  defp parse(body) do
    cell_position = 15
    unit_position = 13

    {_, _, wrapper} =
    body
    |> Floki.find(".cell")
    |> Enum.at(cell_position)

    number =
      wrapper
      |> Floki.find(".cell__value")
      |> Floki.text

    unit =
      wrapper
      |> Floki.find(".cell__label")
      |> Floki.text
      |> String.slice(unit_position, 1)
      |> String.upcase
  end

  defp url(ticker) do
      "http://www.bloomberg.com/quote/#{ticker}:US"
  end
end
