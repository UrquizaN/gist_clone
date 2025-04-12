defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistClone.Gists.Gist

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
