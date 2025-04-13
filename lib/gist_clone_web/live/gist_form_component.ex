defmodule GistCloneWeb.GistFormComponent do
  use GistCloneWeb, :live_component

  alias GistClone.Gists
  alias GistClone.Gists.Gist

  def mount(socket) do
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

  def handle_event("submit", %{"gist" => gist_params}, socket) do
    if socket.assigns.id do
      handle_update(socket, Map.put(gist_params, "id", socket.assigns.id))
    else
      handle_create(socket, gist_params)
    end
  end

  defp handle_create(socket, gist_params) do
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

  defp handle_update(socket, gist_params) do
    case Gists.update_gist(socket.assigns.current_user, gist_params) do
      {:ok, _gist} ->
        {:noreply, push_patch(socket, to: ~p"/gist/#{gist_params["id"]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        class="flex flex-col gap-6"
        phx-change="validate"
        phx-submit="submit"
        phx-target={@myself}
      >
        <.input
          field={@form[:description]}
          placeholder="Gist description..."
          class="mt-0 bg-dark/90 border border-gray-500 text-white"
          phx-debounce="blur"
        />

        <div class="flex flex-col border border-gray-500 rounded-lg">
          <div class=" p-3 bg-dark-400/50 rounded-t-lg">
            <.input
              field={@form[:name]}
              placeholder="Filename including extension"
              class="mt-0 bg-dark/90 border border-gray-500 text-white"
              phx-debounce="blur"
            />
          </div>
          <div
            id="line-numbers-container"
            class="grid grid-cols-[82px_1fr] w-full"
            phx-update="ignore"
          >
            <textarea
              id="line-numbers"
              class="mt-1 min-h-52 text-right outline-none focus:ring-0 rounded-lg border-none bg-transparent text-gray-400 leading-3 resize-none overflow-hidden"
              readonly
              tabindex="-1"
            >
          <%= "1\n" %>
          </textarea>
            <.input
              field={@form[:markup_text]}
              placeholder="Enter your code..."
              type="textarea"
              class="flex-1 rounded-b-lg rounded-t-none resize-none bg-dark/30 border-transparent border-none text-white w-full h-full"
              phx-debounce="blur"
              phx-hook="UpdateLineNumbers"
              id="markup-text"
            />
          </div>
        </div>

        <.button
          class="bg-lavender-900 hover:bg-lavender w-32 self-end p-2 rounded-lg"
          phx-disable-with={if(@id == :new_gist, do: "Creating...", else: "Updating...")}
        >
          {if(@id == :new_gist, do: "Create", else: "Update")} gist
        </.button>
      </.form>
    </div>
    """
  end
end
