defmodule SnowPortalWeb.RequireAdmin do
  use SnowPortalWeb, :html

  def on_mount(_default, _params, _session, socket) do
    current_user = socket.assigns.current_user

    if current_user.role == :ADMIN do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must admin to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end
end
