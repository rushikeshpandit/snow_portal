defmodule SnowPortalWeb.Customer.DashboardLive.Index do
  use SnowPortalWeb, :live_view

  def handle_params(params, _uri, socket),
    do:
      {:noreply,
       socket
       |> apply_action(socket.assigns.live_action, params)}

  defp apply_action(socket, :index, _params),
    do: socket |> assign(:page_title, "Customer Dashboard")

  def handle_event("create_ticket", _, socket),
    do: {:noreply, socket |> push_navigate(to: ~p"/customer/tickets/new")}

  def handle_event("manage_tickets", _, socket),
    do: {:noreply, socket |> push_navigate(to: ~p"/customer/tickets")}
end
