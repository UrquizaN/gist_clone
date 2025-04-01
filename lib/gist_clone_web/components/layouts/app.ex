defmodule GistCloneWeb.Layouts.App do
  alias Phoenix.LiveView.JS

  def toggle_dropdown(selector) do
    JS.toggle(
      to: selector,
      in:
        {"transition ease-out duration-100", "transform opacity-0 -translate-y-4",
         "transform opacity-100 translate-y-0"},
      out:
        {"transition ease-out duration-100", "transform opacity-100 translate-y-0",
         "transform opacity-0 -translate-y-4"}
    )
  end
end
