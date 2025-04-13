defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistClone.Gists.Gist

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(Gists.change_gist(%Gist{})))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-2xl font-bold text-white text-center pt-5">
        Instantly share Elixir code, notes, and snippets.
      </h1>
      <div class="w-1/2 mx-auto py-10">
        <.live_component
          module={GistCloneWeb.GistFormComponent}
          id={:new_gist}
          current_user={@current_user}
          form={@form}
        />
      </div>
    </div>
    """
  end
end
