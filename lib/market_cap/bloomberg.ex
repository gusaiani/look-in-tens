defmodule Dez.Scraper.MarketCap.Bloomberg do
  @moduledoc """
  Retrieves, scrapes, parses and sends mkt cap to coordinator from Bloomberg website.

  Uses @cell_position to find the html element containing mkt cap position.

  Uses @unit_char_position to find the mkt cap unit, be it m, b, k etc.
  It is a substring of a string like this:
    "market cap (b usd)"
  So in this case it retrieves the b for multiplication in the number helper.
  """

  alias Dez.NumberHelper

  @cell_position 15 # Position at which mkt cap <div class="cell"> is displayed in html body.
  @unit_char_position 13 # Position at which mkt cap "unit" character appears in string, see moduledoc.

  def start(sender_pid, ticker) do
    send(sender_pid, fetch(ticker))
  end

  def fetch(ticker) do
    case ticker |> sanitize |> url |> HTTPoison.get do
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

  @spec sanitize(String.t) :: String.t
  defp sanitize(ticker) do
    ticker |> String.replace(".", "/")
  end

  defp parse(body) do
    node = parse_node(body)

    number = parse_number(node)
    unit = parse_unit(node)

    {number, unit}
  end

  defp parse_node(body) do
    {_, _, node} =
      body
      |> Floki.find(".cell")
      |> Enum.at(@cell_position)

    node
  end

  defp parse_number(node) do
    {number, _} =
      node
      |> Floki.find(".cell__value")
      |> Floki.text
      |> String.trim
      |> Float.parse

    number
  end

  defp parse_unit(node) do
    node
    |> Floki.find(".cell__label")
    |> Floki.text
    |> String.slice(@unit_char_position, 1)
    |> String.upcase
  end

  defp url(ticker) do
    "http://www.bloomberg.com/quote/#{ticker}:US"
  end
end
