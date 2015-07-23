defmodule Dez.CompanyController do
  use Dez.Web, :controller

  alias Dez.Company

  plug :scrub_params, "company" when action in [:create, :update]

  def scrape do
    new_name  = fake_name()
    changeset = Company.changeset(%Company{}, %{"name" => new_name})

    if changeset.valid? do
      Repo.insert!(changeset)
      IO.puts "New company added: #{new_name}!"
    end
  end

  def index(conn, _params) do
    companies = Repo.all(Company)
    render(conn, "index.html", companies: companies)
  end

  def new(conn, _params) do
    changeset = Company.changeset(%Company{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    changeset = Company.changeset(%Company{}, company_params)

    if changeset.valid? do
      Repo.insert!(changeset)

      conn
      |> put_flash(:info, "Company created successfully.")
      |> redirect(to: company_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.html", company: company)
  end

  def edit(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    changeset = Company.changeset(company)
    render(conn, "edit.html", company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    company = Repo.get!(Company, id)
    changeset = Company.changeset(company, company_params)

    if changeset.valid? do
      Repo.update!(changeset)

      conn
      |> put_flash(:info, "Company updated successfully.")
      |> redirect(to: company_path(conn, :index))
    else
      render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    Repo.delete!(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: company_path(conn, :index))
  end

  defp fake_name do
    :crypto.strong_rand_bytes(4)
    |> :base64.encode_to_string
    |> to_string
  end
end
