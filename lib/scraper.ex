defmodule Scraper do
  alias Dez.Company
  alias Dez.Repo

  def scrape do
    url = "https://raw.githubusercontent.com/matthewfieger/bloomberg_stock_data/master/tickers/nyse.csv"

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
      |> ExCsv.parse(headings: true)

    IO.inspect table.headings
    add table.body
  end

  defp add([]) do
    IO.puts "Finished"
  end

  defp add([head|tail]) do
    name   = Enum.at(head, 1)
    ticker = Enum.at(head, 0)
    pe = Float.floor(:random.uniform * 20, 2)

    changeset = Company.changeset(%Company{}, %{"name" => name, "ticker" => ticker, "pe" => pe})

    if changeset.valid? do
      Repo.insert!(changeset)
      IO.puts "New company added: #{name}!"
    end

    add tail
  end
end
