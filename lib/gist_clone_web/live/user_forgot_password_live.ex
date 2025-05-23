defmodule GistCloneWeb.UserForgotPasswordLive do
  use GistCloneWeb, :live_view

  alias GistClone.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto my-20 max-w-lg bg-dark/50 p-10 border border-lavender/30 rounded-lg">
      <.header class="text-center text-white mb-5">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="send_email"
        class="flex flex-col gap-y-5"
      >
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button
            phx-disable-with="Sending..."
            class="w-full bg-lavender p-2 rounded-lg hover:bg-lavender-900 transition-colors duration-300"
          >
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4 text-lavender">
        <.link href={~p"/users/register"}>Register</.link>
        | <.link href={~p"/users/log_in"}>Log in</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
