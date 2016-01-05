defmodule Dez.CompanyControllerTest do
  use Dez.ConnCase

  alias Dez.Company

  @valid_attrs %{name: "some content", ticker: "some ticker", pe: 1.13}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "shows chosen company", %{conn: conn} do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    company = Repo.insert! changeset
    conn = get conn, company_path(conn, :show, company)

    assert json_response(conn, 200)["company"] == %{
      "id" => company.id,
      "name" => company.name,
      "ticker" => company.ticker,
      "pe" => company.pe}
  end

  test "does not show company and instead throws error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, company_path(conn, :show, -1)
    end
  end

  test "finds searched company", %{conn: conn} do
    query_str = "some"
    changeset = Company.changeset(%Company{}, @valid_attrs)
    company = Repo.insert! changeset
    
    conn = get conn, company_path(conn, :search, query_str)

    assert json_response(conn, 200)["companies"] == [%{
      "id" => company.id,
      "name" => company.name,
      "ticker" => company.ticker,
      "pe" => company.pe}]
  end
end
