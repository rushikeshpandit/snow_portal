defmodule SnowPortalWeb.Admin.DashboardLive.Index do
  use SnowPortalWeb, :live_view

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action

    socket =
      socket
      |> apply_action(live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket |> assign(:page_title, "Admin Dashboard")
  end
end
