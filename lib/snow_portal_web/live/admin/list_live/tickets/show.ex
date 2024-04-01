defmodule SnowPortalWeb.Admin.ListLive.Tickets.Show do
  use SnowPortalWeb, :live_view
  alias SnowPortal.TicketPhoto
  alias SnowPortal.Tickets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    ticket = Tickets.get_ticket!(id)
    ticket_attachments = Enum.map(ticket.ticket_attachments, &get_attachment_image_url(&1))
    IO.inspect(ticket, label: "handle_params ticket *****")
    IO.inspect(ticket_attachments, label: "handle_params ticket_attachments *****")

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
end
