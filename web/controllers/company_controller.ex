defmodule Dez.CompanyController do
  use Dez.Web, :controller

  alias Dez.Company

  plug :scrub_params, "company" when action in [:create, :update]

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

  # def scrape do
  #   new_name  = fake_name()
  #   changeset = Company.changeset(%Company{}, %{"name" => new_name})

  #   if changeset.valid? do
  #     Repo.insert!(changeset)
  #     IO.puts "New company added: #{new_name}!"
  #   end
  # end

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
    company_name   = Enum.at(head, 1)
    company_ticker = Enum.at(head, 0)

    changeset = Company.changeset(%Company{}, %{"name" => company_name})

    if changeset.valid? do
      Repo.insert!(changeset)
      IO.puts "New company added: #{company_name}!"
    end

    add tail
  end

end
