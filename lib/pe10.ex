defmodule Dez.PE10 do
  def calc(market_cap, net_income)
  when is_float(market_cap) and is_float(net_income) do
    IO.inspect "Market cap: #{market_cap}"
    IO.inspect "Net Income: #{net_income}"
    {:ok, market_cap / net_income}
  end

  def calc(_, _) do
    :error
  end
end
