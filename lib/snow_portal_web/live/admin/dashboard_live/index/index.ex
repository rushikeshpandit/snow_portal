defmodule SnowPortalWeb.Admin.DashboardLive.Index do
  use SnowPortalWeb, :live_view
  alias SnowPortalWeb.Admin.DashboardLive.Form

  def handle_params(params, _uri, socket),
    do: {:noreply, socket |> apply_action(socket.assigns.live_action, params)}

  defp apply_action(socket, :index, _params),
    do: socket |> assign(:page_title, "Admin Dashboard") |> assign(type: nil)

  def handle_event("add_executive", _, socket), do: {:noreply, socket |> assign(type: :EXECUTIVE)}

  def handle_event("add_user", _, socket), do: {:noreply, socket |> assign(type: :USER)}
end
