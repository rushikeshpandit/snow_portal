defmodule SnowPortalWeb.HeaderComponent do
  use SnowPortalWeb, :html

  def menu(assigns) do
    ~H"""
    <nav class="flex items-center justify-between py-4">
      <a href="/" id="logo">
        <img src={~p"/images/logo.jpg"} alt="" class="h-30 w-20" />
      </a>
      <ul class="flex items-center">
        <%= if @current_user do %>
          <%= if @current_user.role == :ADMIN do %>
            <li class="ml-6">
              <.link href={~p"/admin/list_executive"}>List Executives</.link>
            </li>
            <li class="ml-6">
              <.link href={~p"/admin/list_user"}>List Users</.link>
            </li>
          <% else %>
            <li class="ml-6">
              <.link href={~p"/"}>List Tickets</.link>
            </li>
          <% end %>
          <li class="ml-6">
            <.link href={~p"/users/settings"}>Settings</.link>
          </li>
          <li class="ml-6">
            <span class="text-orange-500"><%= @current_user.email %></span>
            <.link href={~p"/users/log_out"} method="delete">Log out</.link>
          </li>
        <% else %>
          <li class="ml-6">
            <.link href={~p"/users/register"}>Register</.link>
          </li>
          <li class="ml-6">
            <.link href={~p"/users/log_in"}>Log in</.link>
          </li>
        <% end %>
      </ul>
    </nav>
    """
  end
end
