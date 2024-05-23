defmodule SnowPortalWeb.Customer.TicketLive.Show do
  alias SnowPortal.TicketComments
  alias SnowPortal.Tickets.TicketComment
  use SnowPortalWeb, :live_view
  alias SnowPortal.TicketPhoto
  alias SnowPortal.Tickets
  alias SnowPortal.NewTicket

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: NewTicket.subscribe_update_ticket()
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    ticket = Tickets.get_ticket!(id)
    ticket_attachments = Enum.map(ticket.ticket_attachments, &get_attachment_image_url(&1))

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ticket, ticket)
     |> assign(:ticket_attachments, ticket_attachments)}
  end

  defp page_title(:show), do: "Show Ticket"
  defp page_title(:edit), do: "Edit Ticket"

  defp get_attachment_image_url(attachment),
    do: TicketPhoto.url({attachment.image_url, attachment})

  @impl true

  def handle_info(
        {SnowPortalWeb.Executive.ListLive.Tickets.FormComponent, {:save_comment, ticket_comment}},
        socket
      ) do
    {:noreply,
     socket |> assign(:comments, TicketComments.list_tickets_comments(ticket_comment.id))}
  end

  def handle_info({:update_ticket, ticket}, socket) do
    new_ticket = Tickets.get_ticket!(ticket.id)
    ticket_attachments = Enum.map(ticket.ticket_attachments, &get_attachment_image_url(&1))

    socket =
      socket
      |> assign(:ticket, new_ticket)
      |> assign(:ticket_attachments, ticket_attachments)

    {:noreply, socket}
  end
end
