defmodule Dez.Scraper.NetIncome do
  @moduledoc """

  """
  alias Dez.NumberHelper

  @trimesters 40

  # def loop do
  #   receive do
  #     {sender_pid, company} ->
  #       ticker = Enum.at(company, 0)
  #       send(sender_pid, {:ok, company, fetch(ticker)})
  #   end
  #   loop
  # end


  def fetch(company, coordinator_pid) do
    ticker = Enum.at(company, 0)

    case ticker |> url |> HTTPoison.get do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect "Found net income url for #{ticker}."
        net_income =
          body
          |> parse_quarterly
          |> average
          |> annualize

        send(coordinator_pid, {:ok, company, net_income})

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Net income url for #{ticker} not found."
        send(coordinator_pid, :error)
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        send(coordinator_pid, :error)
    end
  end

  def parse_quarterly(body) do
    body
    |> Floki.find(".histDataTable td")
    |> Enum.with_index
    |> Enum.map(fn({entry, index}) -> parse_quarterly_income({entry, index}) end)
    |> Enum.with_index
    |> Enum.filter(fn({_entry, index}) -> rem(index, 2) != 0 end)
    |> Enum.map(fn({entry, _index}) -> entry end)
    |> Enum.take(@trimesters)
  end

  defp average(incomes) do
    Enum.reduce(incomes, &(&1+&2)) / length(incomes)
  end

  defp parse_quarterly_income({entry, index}) when rem(index, 2) == 0 do
    date_array =
      entry
      |> Floki.text()
      |> String.split([" "])

    month_name = Enum.at(date_array, 0)
    month = get_month_number(month_name)

    day = String.replace(Enum.at(date_array, 1), ",", "")
    year = Enum.at(date_array, 2)

    "#{year}-#{month}-#{day}"
  end

  defp parse_quarterly_income({entry, _}) do
    entry
    |> Floki.text
    |> String.trim
    |> Float.parse
    |> NumberHelper.parse
  end

  defp annualize(income) do
    income * 4
  end

  defp get_month_number(month_name) do
    months = %{
      "Jan." => "01",
      "Feb." => "02",
      "March" => "03",
      "April" => "04",
      "May" => "05",
      "June" => "06",
      "July" => "07",
      "Aug." => "08",
      "Sept." => "09",
      "Oct." => "10",
      "Nov." => "11",
      "Dec." => "12"
    }

    months[month_name]
  end

  defp url(ticker) do
    "https://ycharts.com/companies/#{ticker}/net_income"
  end
end
