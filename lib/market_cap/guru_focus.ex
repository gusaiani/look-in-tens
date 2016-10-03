defmodule Dez.Scraper.MarketCap.GuruFocus do
  @moduledoc """
  Retrieves, scrapes, parses and sends mkt cap to coordinator from Guru Focus website.
  """

  alias Dez.NumberHelper

  def start(sender_pid, ticker) do
    send(sender_pid, fetch(ticker))
  end

  def fetch(ticker) do
    case ticker |> url |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect "Found net income url for #{ticker}."
        body
        |> parse
        |> NumberHelper.parse

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Net income url for #{ticker} not found."
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        :error
    end
  end

  defp parse(body) do
    [_, value_text, unit_text, _, _, _] =
      body
      |> Floki.find(".data_value")
      |> Floki.text
      |> String.split(["$", " "])

    value = parse_value(value_text)
    unit = parse_unit(unit_text)

    {value, unit}
  end

  defp parse_value(text) do
    {value, _} =
      text
      |> String.replace(",", "")
      |> Float.parse

    value
  end

  defp parse_unit(text) do
    text
    |> String.slice(0, 1)
  end

  defp url(ticker) do
    "http://www.gurufocus.com/term/mktcap/#{ticker}/Market-Cap/"
  end
end
