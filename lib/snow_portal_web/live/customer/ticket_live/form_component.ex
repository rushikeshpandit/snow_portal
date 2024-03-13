defmodule SnowPortalWeb.Customer.TicketLive.FormComponent do
  use SnowPortalWeb, :live_component

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

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:types, types)
     |> assign(:priority, priority)
     |> assign(:current_user, current_user)
     |> assign_form(changeset)
     |> allow_upload(:attachments, @upload_options)}
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
    {attachments, []} = uploaded_entries(socket, :attachments)
    images = Enum.map(attachments, &%{image: &1})

    case Tickets.update_ticket(ticket_params.assigns.ticket, ticket_params) do
      {:ok, ticket} ->
        notify_parent({:saved, ticket})

        {:noreply,
         socket
         |> put_flash(:info, "Ticket updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_ticket(socket, :new, ticket_params) do
    attachments =
      consume_uploaded_entries(socket, :attachments, fn %{path: path}, _entry ->
        dest =
          Path.join(Application.app_dir(:snow_portal, "priv/static/uploads"), Path.basename(path))

        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    user_id = socket.assigns.current_user.id

    attachments =
      Enum.map(
        attachments,
        &%{
          image_url: &1,
          user_id: user_id
        }
      )

    ticket_params = Map.put(ticket_params, "attachments", attachments)

    case Tickets.create_ticket(ticket_params) do
      {:ok, ticket} ->
        notify_parent({:saved, ticket})

        {:noreply,
         socket
         |> put_flash(:info, "Ticket created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
