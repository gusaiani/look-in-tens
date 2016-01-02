defmodule Dez.PageControllerTest do
  use Dez.ConnCase

  test "GET /" do
    conn = get conn(), "/about"
    assert html_response(conn, 200) =~ "Welcome"
  end
end
