defmodule SnowPortalWeb.Admin.DashboardLive.Form do
  use SnowPortalWeb, :live_component

  alias SnowPortal.Accounts
  alias SnowPortal.Accounts.User

  def update(assigns, socket) do
    IO.inspect(assigns, label: "update assigns ***** ")
    IO.inspect(socket, label: "update socket ***** ")
    form = to_form(%{"role" => assigns.type}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false, check_errors: false)}
  end

  # def mount(params, session, socket) do
  #   IO.inspect(params, label: "mount params ***** ")
  #   IO.inspect(session, label: "mount session ***** ")
  #   changeset = Accounts.change_user_registration(%User{})

  #   socket =
  #     socket
  #     |> assign(trigger_submit: false, check_errors: false)
  #     |> assign_form(changeset)

  #   {:ok, socket}
  # end

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action

    socket =
      socket
      |> apply_action(live_action, params)

    {:noreply, socket}
  end

  defp apply_action(socket, :create, _params) do
    socket |> assign(:page_title, "Admin Dashboard")
  end

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
