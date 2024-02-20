defmodule SnowPortalWeb.UserLoginLive do
  use SnowPortalWeb, :live_view
  import Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>
      <p><%= @form.params["login_as"] %></p>
      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="replace">
        <p>Login with</p>
        <fieldset class="flex items-center justify-between px-4">
          <.input
            phx-change="change-radio-input"
            field={@form[:login_as]}
            id="login_with_username"
            type="radio"
            label="Username"
            value="username"
            checked={@form[:login_as].value == :username || @form.params["login_as"] == "username"}
          />
          <.input
            phx-change="change-radio-input"
            field={@form[:login_as]}
            id="login_with_email"
            type="radio"
            label="Email"
            value="email"
            checked={@form[:login_as].value == :email || @form.params["login_as"] == "email"}
          />
        </fieldset>
        <%= if @form[:login_as] && @form.params["login_as"] == "username" do %>
          <.input id="login-username" field={@form[:user_name]} placeholder="Username" required />
        <% else %>
          <.input id="login-email" field={@form[:email]} placeholder="Email" required />
        <% end %>

        <.input field={@form[:password]} type="password" placeholder="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(params, session, socket) do
    form = to_form(%{"login_as" => "email"}, as: "user")
    {:ok, assign(socket, form: form)}
  end

  def handle_event("change-radio-input", %{"user" => user_params}, socket) do
    %{"login_as" => login_as} = user_params
    form = to_form(%{"login_as" => login_as}, as: "user")
    socket = socket |> assign(form: form)
    {:noreply, socket}
  end
end
