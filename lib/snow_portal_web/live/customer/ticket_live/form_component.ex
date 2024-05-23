defmodule SnowPortalWeb.Customer.TicketLive.FormComponent do
  alias SnowPortal.NewTicket
  use SnowPortalWeb, :live_component
  alias SnowPortal.TicketPhoto
  alias SnowPortal.Tickets

  @upload_options [
    accept: ~w/.jpg .jpeg .png .svg .doc .docx .txt .rar .zip .pdf/,
    max_entries: 10
  ]

  @impl true
  def update(%{ticket: ticket, current_user: current_user} = assigns, socket) do
    changeset = Tickets.change_ticket(ticket)
    types = Tickets.list_user_role_types()
    priority = Tickets.list_ticket_priority_types()

    socket =
      socket
      |> assign(assigns)
      |> assign(:types, types)
      |> assign(:priority, priority)
      |> assign(:ticket, ticket)
      |> assign(:created_by_user_id, current_user)
      |> assign_form(changeset)
      |> allow_upload(:ticket_attachments, @upload_options)

    if Ecto.assoc_loaded?(ticket.ticket_attachments) do
      ticket_attachments = Enum.map(ticket.ticket_attachments, &get_attachment_image_url(&1))

      {:ok,
       socket
       |> assign(:ticket_attachments, ticket_attachments)}
    else
      {:ok,
       socket
       |> assign(:ticket_attachments, nil)}
    end
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
    save_ticket(socket, socket.assigns.action, ticket_params)
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image_url, ref)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  defp save_ticket(socket, :edit, ticket_params) do
    perform(
      socket,
      Tickets.update_ticket(socket.assigns.ticket, ticket_params),
      "Ticket updated successfully"
    )
  end

  defp save_ticket(socket, :new, ticket_params) do
    perform(
      socket,
      Tickets.create_ticket(ticket_params),
      "Ticket created successfully"
    )
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  defp perform(socket, function_result, message) do
    case function_result do
      {:ok, ticket} ->
        notify_parent({:saved, ticket})
        {ticket_attachments, []} = uploaded_entries(socket, :ticket_attachments)
        build_image_url(socket)

        ticket_attachments =
          Enum.map(ticket_attachments, fn attachment ->
            "#{get_image_url(attachment)}"
          end)

        current_user = socket.assigns.current_user

        ticket_attachments =
          Enum.map(
            ticket_attachments,
            &%{image_url: &1, ticket_id: ticket.id, user_id: current_user.id}
          )

        Tickets.create_images(ticket.id, ticket_attachments)

        NewTicket.broadcast_new_ticket({:ok, ticket})
        NewTicket.broadcast_update_ticket({:ok, ticket})

        socket =
          socket
          |> put_flash(:info, message)
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp get_file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  def get_image_url(entry) do
    "priv/static/uploads/#{get_file_name(entry)}"
  end

  defp build_image_url(socket) do
    consume_uploaded_entries(socket, :ticket_attachments, fn meta, entry ->
      file_name = get_file_name(entry)

      dest = Path.join("priv/static/uploads", file_name)

      {:ok, File.cp!(meta.path, dest)}
    end)
  end

  defp get_attachment_image_url(attachment),
    do: TicketPhoto.url({attachment.image_url, attachment})
end
