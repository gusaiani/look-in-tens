defmodule Dez.CompanyController do
  use Dez.Web, :controller

  alias Dez.Company

  plug :scrub_params, "company" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.json", company: company)
  end

  def search(conn, %{"query_str" => query_str}) do
    companies = Repo.all from c in Company,
                where: ilike(c.name, ^"#{query_str}%")
                       or ilike(c.ticker, ^"#{query_str}%"),
                limit: 5
    render(conn, "search.json", companies: companies)
  end
end
