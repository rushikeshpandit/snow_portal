defmodule SnowPortalWeb.Executive.ListLive.Tickets.CommentComponent do
  use SnowPortalWeb, :live_component

  @impl true
  def update(%{ticket_comment: ticket_comment} = assigns, socket) do
    socket = socket |> assign(assigns) |> assign(:ticket_comment, ticket_comment)
    {:ok, socket}
  end
end
