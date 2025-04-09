defmodule GistCloneWeb.CreateGistLive do
  use GistCloneWeb, :live_view

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
      {:ok, gist} ->
        socket = push_event(socket, "clear-textarea", %{})

        form = %Gist{} |> Gists.change_gist() |> to_form()
        socket = assign(socket, form: form)

        {:noreply, push_navigate(socket, to: ~p"/gist/#{gist.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
