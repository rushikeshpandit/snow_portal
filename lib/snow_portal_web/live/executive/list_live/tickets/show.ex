defmodule SnowPortalWeb.Executive.ListLive.Tickets.Show do
  alias SnowPortal.Accounts
  use SnowPortalWeb, :live_view
  alias SnowPortal.TicketPhoto
  alias SnowPortal.Tickets
  alias SnowPortal.TicketComments
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
    comments = TicketComments.list_tickets_comments(id)

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:ticket, ticket)
      |> assign(:ticket_attachments, ticket_attachments)
      |> assign(:comments, comments)

    if !is_nil(ticket.assigned_to_user_id) do
      assigned_to_user_id = Accounts.get_user!(ticket.assigned_to_user_id)

      {:noreply,
       socket
       |> assign(:assigned_to_user_id, assigned_to_user_id)
       |> assign(:assigned_user_id, ticket.assigned_to_user_id)}
    else
      {:noreply,
       socket
       |> assign(:assigned_to_user_id, nil)}
    end
  end

  @impl true
  def handle_info(
        {SnowPortalWeb.Executive.ListLive.Tickets.FormComponent, {:save_comment, ticket_comment}},
        socket
      ) do
    {:noreply,
     socket |> assign(:comments, TicketComments.list_tickets_comments(ticket_comment.ticket_id))}
  end

  def handle_info({:update_ticket, ticket}, socket) do
    new_ticket = Tickets.get_ticket!(ticket.id)
    ticket_attachments = Enum.map(ticket.ticket_attachments, &get_attachment_image_url(&1))
    comments = TicketComments.list_tickets_comments(ticket.id)

    socket =
      socket
      |> assign(:ticket, new_ticket)
      |> assign(:ticket_attachments, ticket_attachments)
      |> assign(:comments, comments)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show Ticket"

  defp get_attachment_image_url(attachment),
    do: TicketPhoto.url({attachment.image_url, attachment})
end
