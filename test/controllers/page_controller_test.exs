defmodule Dez.PageControllerTest do
  use Dez.ConnCase

  test "About page" do
    conn = get conn(), "/about"
    assert html_response(conn, 200) =~ "Welcome"
  end
end
