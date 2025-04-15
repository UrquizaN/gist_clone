defmodule GistCloneWeb.UserLoginLive do
  use GistCloneWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto my-10 max-w-lg bg-dark/50 p-10 border border-lavender/30 rounded-lg">
      <.header class="text-center text-white mb-5">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="login_form"
        action={~p"/users/log_in"}
        phx-update="ignore"
        class="flex flex-col gap-y-5"
      >
        <.input field={@form[:email]} type="email" label="Email" required class="text-gray-700" />
        <.input
          field={@form[:password]}
          type="password"
          label="Password"
          required
          class="text-gray-700 "
        />

        <:actions>
          <.input
            field={@form[:remember_me]}
            type="checkbox"
            label="Keep me logged in"
            class="text-lavender"
          />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold text-lavender">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button
            phx-disable-with="Logging in..."
            class="w-full bg-lavender p-2 rounded-lg hover:bg-lavender-900 transition-colors duration-300"
          >
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
