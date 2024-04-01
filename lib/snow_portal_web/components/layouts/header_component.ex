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
          <.get_menu_list role={@current_user.role} email={@current_user.email} />
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

  defp get_menu_list(%{role: :ADMIN} = assigns) do
    ~H"""
    <li class="ml-6">
      <.link href={~p"/admin/list_executive"}>List Executives</.link>
    </li>
    <li class="ml-6">
      <.link href={~p"/admin/list_user"}>List Users</.link>
    </li>
    <li class="ml-6">
      <.link href={~p"/admin/list_tickets"}>List Tickets</.link>
    </li>
    <.get_common_menu email={@email} />
    """
  end

  defp get_menu_list(%{role: :USER} = assigns) do
    ~H"""
    <li class="ml-6">
      <.link href={~p"/customer/tickets/new"}>Create Ticket</.link>
    </li>
    <li class="ml-6">
      <.link href={~p"/customer/tickets"}>Manage Tickets</.link>
    </li>
    <.get_common_menu email={@email} />
    """
  end

  defp get_menu_list(%{role: :EXECUTIVE} = assigns) do
    ~H"""
    <li class="ml-6">
      <.link href={~p"/"}>List Tickets</.link>
    </li>
    <.get_common_menu email={@email} />
    """
  end

  defp get_common_menu(assigns) do
    ~H"""
    <li class="ml-6">
      <.link href={~p"/users/settings"}>Settings</.link>
    </li>
    <li class="ml-6">
      <span class="text-orange-500"><%= @email %></span>
    </li>
    <li class="ml-6">
      <.link href={~p"/users/log_out"} method="delete">Log out</.link>
    </li>
    """
  end
end
