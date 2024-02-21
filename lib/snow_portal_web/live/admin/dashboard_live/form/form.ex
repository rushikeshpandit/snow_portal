defmodule SnowPortalWeb.Admin.DashboardLive.Form do
  use SnowPortalWeb, :live_component

  alias SnowPortal.Accounts
  alias SnowPortal.Accounts.User

  def update(assigns, socket),
    do:
      {:ok,
       assign(socket,
         form: to_form(%{"role" => assigns.type}, as: "user"),
         trigger_submit: false,
         check_errors: false
       )}

  def handle_params(params, _uri, socket),
    do: {:noreply, socket |> apply_action(socket.assigns.live_action, params)}

  defp apply_action(socket, :create, _params),
    do: socket |> assign(:page_title, "Admin Dashboard")

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        message = "User has been added succesfully"

        {:noreply,
         socket
         |> assign(trigger_submit: true)
         |> assign_form(changeset)
         |> put_flash(:info, message)}

      {:error, %Ecto.Changeset{} = changeset} ->
        message = "Something went wrong"

        {:noreply,
         socket
         |> assign(check_errors: true)
         |> assign_form(changeset)
         |> put_flash(:error, message)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    role = socket.assigns.form.params["role"]

    changeset = Accounts.change_user_registration(%User{}, user_params)
    changeset = changeset |> Map.put(:role, role)

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
