defmodule SnowPortalWeb.Common.AttachmentComponent do
  use SnowPortalWeb, :live_component

  @impl true
  def update(%{ticket_attachment: ticket_attachment} = assigns, socket) do
    socket = socket |> assign(assigns) |> assign(:ticket_attachment, ticket_attachment)
    {:ok, socket}
  end
end
