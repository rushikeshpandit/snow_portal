defmodule SnowPortalWeb.Admin.ListLive.Tickets.Index do
  use SnowPortalWeb, :live_view

  alias SnowPortal.Tickets
  alias SnowPortal.NewTicket

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      NewTicket.subscribe_new_ticket()
      NewTicket.subscribe_update_ticket()
    end

    {:ok, stream(socket, :tickets, Tickets.list_tickets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tickets")
    |> assign(:ticket, nil)
  end

  @impl true
  def handle_info({SnowPortalWeb.Customer.TicketLive.FormComponent, {:saved, ticket}}, socket) do
    {:noreply, stream_insert(socket, :tickets, ticket)}
  end

  def handle_info({:new_ticket, _ticket}, socket) do
    {:noreply, stream(socket, :tickets, Tickets.list_tickets())}
  end

  def handle_info({:update_ticket, _ticket}, socket) do
    {:noreply, stream(socket, :tickets, Tickets.list_tickets())}
  end
end
