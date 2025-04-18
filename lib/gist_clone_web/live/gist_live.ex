defmodule GistCloneWeb.GistLive do
  use GistCloneWeb, :live_view

  alias GistClone.Gists
  alias GistCloneWeb.Utils.DateFormat

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    socket =
      socket
      |> assign(edit_gist: nil)
      |> assign_saved_gist(gist)
      |> assign(gist: gist)

    {:ok, socket}
  end

  def assign_saved_gist(socket, gist) do
    current_user = socket.assigns.current_user

    if current_user.id != gist.user_id do
      saved_gist = Gists.saved_gist_by_user_id_and_gist_id(current_user, gist.id)
      assign(socket, saved_gist: saved_gist)
    else
      assign(socket, saved_gist: nil)
    end
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

  def handle_event("save", %{"id" => id}, socket) do
    saved_gist = socket.assigns.saved_gist

    if is_nil(saved_gist) do
      create_saved_gist(socket, id)
    else
      delete_saved_gist(socket, id)
    end
  end

  defp create_saved_gist(socket, gist_id) do
    case Gists.create_saved_gist(socket.assigns.current_user, %{gist_id: gist_id}) do
      {:ok, saved_gist} ->
        {:noreply,
         put_flash(socket, :info, "Gist successfully saved") |> assign(saved_gist: saved_gist)}

      {:error, error} ->
        {:noreply, put_flash(socket, :error, "Failed to save gist: #{error}")}
    end
  end

  defp delete_saved_gist(socket, gist_id) do
    case Gists.delete_saved_gist(socket.assigns.current_user, gist_id) do
      {:ok, _} ->
        socket = assign(socket, saved_gist: nil)
        {:noreply, put_flash(socket, :info, "Gist successfully removed")}

      {:error, error} ->
        {:noreply, put_flash(socket, :error, "Failed to remove gist: #{error}")}
    end
  end
end
