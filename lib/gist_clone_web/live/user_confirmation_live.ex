defmodule GistCloneWeb.UserConfirmationLive do
  use GistCloneWeb, :live_view

  alias GistClone.Accounts

  def render(%{live_action: :edit} = assigns) do
    ~H"""
    <div class="mx-auto my-20 max-w-lg bg-dark/50 p-10 border border-lavender/30 rounded-lg">
      <.header class="text-center text-white mb-5">Confirm Account</.header>

      <.simple_form
        for={@form}
        id="confirmation_form"
        phx-submit="confirm_account"
        class="flex flex-col gap-y-5"
      >
        <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
        <:actions>
          <.button
            phx-disable-with="Confirming..."
            class="w-full bg-lavender p-2 rounded-lg hover:bg-lavender-900 transition-colors duration-300"
          >
            Confirm my account
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center mt-4 text-lavender">
        <.link href={~p"/users/register"}>Register</.link>
        | <.link href={~p"/users/log_in"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    form = to_form(%{"token" => token}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after confirmation to avoid a
  # leaked token giving the user access to the account.
  def handle_event("confirm_account", %{"user" => %{"token" => token}}, socket) do
    case Accounts.confirm_user(token) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "User confirmed successfully.")
         |> redirect(to: ~p"/")}

      :error ->
        # If there is a current user and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the user themselves, so we redirect without
        # a warning message.
        case socket.assigns do
          %{current_user: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            {:noreply, redirect(socket, to: ~p"/")}

          %{} ->
            {:noreply,
             socket
             |> put_flash(:error, "User confirmation link is invalid or it has expired.")
             |> redirect(to: ~p"/")}
        end
    end
  end
end
