defmodule Dez.CompanyView do
  use Dez.Web, :view
  use Timex

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
      pe: Float.floor(company.pe10, 2),
      updatedAt: Timex.format!(company.updated_at, "{relative}", :relative)}
  end
end
