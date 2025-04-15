defmodule GistCloneWeb.AllGistsLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistClone.Repo

  def mount(_params, _session, socket) do
    search_form = to_form(%{"search" => ""})
    {:ok, assign(socket, search_gist: search_form)}
  end

  def handle_params(_params, _uri, socket) do
    gists = Gists.list_gists(socket.assigns.current_user) |> Repo.preload(:user)

    {:noreply, assign(socket, gists: gists)}
  end

  def handle_event("search", %{"search" => search}, socket) do
    gists = Gists.search_gists(socket.assigns.current_user, search) |> Repo.preload(:user)

    {:noreply, assign(socket, gists: gists)}
  end

  defp format_markup_text(markup_text) when is_binary(markup_text) do
    lines = String.split(markup_text, "\n")

    if length(lines) > 10 do
      lines
      |> Enum.take(9)
      |> Enum.join("\n")
      |> Kernel.<>("\n...")
    else
      markup_text
    end
  end

  defp format_markup_text(markup_text), do: markup_text

  def gist(assigns) do
    ~H"""
    <div class="my-6 border border-gray-500 rounded-lg">
      <div class="flex justify-between py-2 px-4 bg-dark rounded-t-lg">
        <div class="flex gap-2">
          <.icon name="hero-user-circle" class="w-10 h-10 text-gray-400" />
          <div>
            <h2 class="text-lg font-bold text-white">
              {@gist.user.email}/<.link
                navigate={~p"/gist/#{@gist.id}"}
                class="text-lavender hover:text-lavender-900 hover:underline"
              ><%= @gist.name %></.link>
            </h2>
            <p class="text-sm text-gray-400">
              {@gist.description}
            </p>
            <p class="text-sm text-gray-400">
              {@gist.updated_at}
            </p>
          </div>
        </div>
        <div class="flex gap-2">
          <div class="flex items-center gap-1 text-white">
            <.icon name="hero-bookmark-solid" class="w-5 h-5 text-gray-400" /> 0
          </div>
          <div class="flex items-center gap-1 text-white">
            <.icon name="hero-chat-bubble-bottom-center-text-solid" class="w-5 h-5 text-gray-400" /> 0
          </div>
        </div>
      </div>
      <div id="highlight" phx-hook="Highlight" data-language={@gist.name} class="grid">
        <pre class="contents">
          <code class="rounded-b-lg">
    <%= format_markup_text(@gist.markup_text)  %>
          </code>
        </pre>
      </div>
    </div>
    """
  end
end
