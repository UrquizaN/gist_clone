defmodule GistCloneWeb.PageController do
  use GistCloneWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home)
    redirect(conn, to: ~p"/create")
  end
end
