defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view
  import Phoenix.HTML.Form

  alias GistClone.Gists
  alias GistClone.Gists.Gist

  def mount(_params, _session, socket) do
    form =
      %Gist{}
      |> Gists.change_gist()
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"gist" => gist_params}, socket) do
    form =
      %Gist{}
      |> Gists.change_gist(gist_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("create", %{"gist" => gist_params}, socket) do
    case Gists.create_gist(socket.assigns.current_user, gist_params) do
      {:ok, _gist} ->
        form = %Gist{} |> Gists.change_gist() |> to_form()
        {:noreply, assign(socket, form: form)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
