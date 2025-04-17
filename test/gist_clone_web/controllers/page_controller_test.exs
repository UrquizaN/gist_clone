defmodule GistCloneWeb.PageControllerTest do
  use GistCloneWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert redirected_to(conn) == ~p"/create"

    conn = get(conn, ~p"/users/log_in")

    assert html_response(conn, 200) =~ "Log in to account"
  end
end
