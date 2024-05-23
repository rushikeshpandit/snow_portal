defmodule SnowPortalWeb.Executive.ListLive.Tickets.Index do
  use SnowPortalWeb, :live_view

  alias SnowPortal.Tickets
  alias SnowPortal.NewTicket

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      NewTicket.subscribe_new_ticket()
      NewTicket.subscribe_update_ticket()
    end

    {:ok, stream(socket, :tickets, Tickets.list_tickets_by_user(socket.assigns.current_user.id))}
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
  def handle_info({:new_ticket, _ticket}, socket) do
    current_user_id = socket.assigns.current_user.id
    {:noreply, stream(socket, :tickets, Tickets.list_tickets_by_user(current_user_id))}
  end

  def handle_info({:update_ticket, _ticket}, socket) do
    current_user_id = socket.assigns.current_user.id
    {:noreply, stream(socket, :tickets, Tickets.list_tickets_by_user(current_user_id))}
  end
end
