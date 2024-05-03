defmodule SnowPortalWeb.Executive.ListLive.Tickets.FormComponent do
  alias SnowPortal.Tickets.TicketComment
  use SnowPortalWeb, :live_component
  alias SnowPortal.TicketComments

  @impl true

  def update(%{id: id, current_user: current_user} = assigns, socket) do
    changeset = TicketComments.change_ticket_comment(%TicketComment{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:ticket_id, id)
      |> assign(:user_id, current_user.id)
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"ticket_comment" => ticket_comment_params}, socket) do
    changeset =
      TicketComments.change_ticket_comment(%TicketComment{}, ticket_comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"ticket_comment" => ticket_comment_params}, socket) do
    {:ok, ticket_comment} =
      TicketComments.create_ticket_comment(ticket_comment_params)

    notify_parent({:save_comment, ticket_comment})

    # socket
    # |> put_flash(:info, "Comment saved successfully !!!")
    # |> push_patch(to: socket.assigns.patch)

    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_info({:saved, _ticket_comment}, socket) do
    socket
    |> put_flash(:info, "Comment saved successfully !!!")
    |> push_patch(to: socket.assigns.patch)

    {:noreply, assign(socket, rerender?: !socket.assigns.rerender?)}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
