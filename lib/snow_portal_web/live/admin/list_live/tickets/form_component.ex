defmodule SnowPortalWeb.Admin.ListLive.Tickets.FormComponent do
  use SnowPortalWeb, :live_component
  alias SnowPortal.Tickets
  alias SnowPortal.Accounts

  @impl true
  def update(%{ticket: ticket} = assigns, socket) do
    changeset = Tickets.change_ticket(ticket)

    executive_list =
      Enum.map(
        Accounts.list_users_by_role(role: :EXECUTIVE),
        &{"#{&1.first_name} #{&1.last_name}", &1.id}
      )

    socket =
      socket
      |> assign(assigns)
      |> assign(:ticket, ticket)
      |> assign(:executive_list, executive_list)
      |> assign_form(changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"ticket" => ticket_params}, socket) do
    changeset =
      socket.assigns.ticket
      |> Tickets.change_ticket(ticket_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"ticket" => ticket_params}, socket) do
    executive_id = ticket_params["executive_id"]
    ticket = Tickets.get_ticket!(ticket_params["ticket_id"])

    update_ticket(socket, :edit, ticket, %{assigned_to_user_id: executive_id})
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image_url, ref)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  defp update_ticket(socket, :edit, ticket, ticket_params) do
    perform(
      socket,
      Tickets.update_ticket(ticket, ticket_params),
      "Ticket updated successfully"
    )
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp perform(socket, function_result, message) do
    case function_result do
      {:ok, ticket} ->
        notify_parent({:saved, ticket})

        socket =
          socket
          |> put_flash(:info, message)
          |> push_navigate(to: socket.assigns.navigate)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
