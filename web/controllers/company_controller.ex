defmodule Dez.CompanyController do
  use Dez.Web, :controller

  alias Dez.Company

  plug :scrub_params, "company" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.json", company: company)
  end
end
