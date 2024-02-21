defmodule SnowPortalWeb.Admin.DashboardLive.Index do
  use SnowPortalWeb, :live_view
  alias SnowPortalWeb.Admin.DashboardLive.Form

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action

    socket =
      socket
      |> apply_action(live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket |> assign(:page_title, "Admin Dashboard") |> assign(type: nil)
  end

  def handle_event("add_executive", _, socket) do
    {:noreply,
     socket
     |> assign(type: :EXECUTIVE)}
  end

  def handle_event("add_user", _, socket) do
    {:noreply,
     socket
     |> assign(type: :USER)}
  end
end
