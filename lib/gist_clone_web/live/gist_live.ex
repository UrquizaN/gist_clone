defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistCloneWeb.Utils.DateFormat

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    socket =
      socket
      |> assign(edit_gist: nil)
      |> assign(gist: gist)

    {:ok, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _} ->
        socket = put_flash(socket, :info, "Gist successfully deleted")
        {:noreply, push_navigate(socket, to: "/create")}

      {:error, error} ->
        socket = put_flash(socket, :error, "Failed to delete gist: #{error}")
        {:noreply, socket}
    end
  end

  def handle_event("edit", %{"edit" => value}, socket) do
    {:noreply, assign(socket, edit_gist: value)}
  end
end
