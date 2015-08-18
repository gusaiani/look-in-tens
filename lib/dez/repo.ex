defmodule Dez.Repo do
  use Ecto.Repo, otp_app: :dez
  use Scrivener, page_size: 10
end
