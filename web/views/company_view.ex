defmodule Dez.CompanyView do
  use Dez.Web, :view

  def render("show.json", %{company: company}) do
    %{company: render_one(company, Dez.CompanyView, "company.json")}
  end

  def render("search.json", %{companies: companies}) do
    %{companies: render_many(companies, Dez.CompanyView, "company.json")}
  end

  def render("company.json", %{company: company}) do
    %{id: company.id,
      name: company.name,
      ticker: company.ticker,
      pe: company.pe}
  end
end
