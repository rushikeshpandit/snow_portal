defmodule SnowPortalWeb.TicketLiveTest do
  use SnowPortalWeb.ConnCase

  import Phoenix.LiveViewTest
  import SnowPortal.TicketsFixtures

  @create_attrs %{
    priority: "some priority",
    type: "INCIDENT",
    description: "some description",
    title: "some title",
    ticket_attachments: "some attachments"
  }
  @update_attrs %{
    priority: "some updated priority",
    type: "SERVICE_REQUEST",
    description: "some updated description",
    title: "some updated title",
    ticket_attachments: "some updated attachments"
  }
  @invalid_attrs %{
    priority: nil,
    type: nil,
    description: nil,
    title: nil,
    ticket_attachments: nil
  }

  defp create_ticket(_) do
    ticket = ticket_fixture()
    %{ticket: ticket}
  end

  describe "Index" do
    setup [:create_ticket]

    test "lists all tickets", %{conn: conn, ticket: ticket} do
      {:ok, _index_live, html} = live(conn, ~p"/customer/tickets")

      assert html =~ "Listing Tickets"
      assert html =~ ticket.priority
    end

    test "saves new ticket", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/customer/tickets")

      assert index_live |> element("a", "New Ticket") |> render_click() =~
               "New Ticket"

      assert_patch(index_live, ~p"/customer/tickets/new")

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ticket-form", ticket: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/customer/tickets")

      html = render(index_live)
      assert html =~ "Ticket created successfully"
      assert html =~ "some priority"
    end

    test "updates ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, ~p"/customer/tickets")

      assert index_live |> element("#tickets-#{ticket.id} a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(index_live, ~p"/customer/tickets/#{ticket}/edit")

      assert index_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#ticket-form", ticket: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/customer/tickets")

      html = render(index_live)
      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated priority"
    end

    test "deletes ticket in listing", %{conn: conn, ticket: ticket} do
      {:ok, index_live, _html} = live(conn, ~p"/customer/tickets")

      assert index_live |> element("#tickets-#{ticket.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tickets-#{ticket.id}")
    end
  end

  describe "Show" do
    setup [:create_ticket]

    test "displays ticket", %{conn: conn, ticket: ticket} do
      {:ok, _show_live, html} = live(conn, ~p"/customer/tickets/#{ticket}")

      assert html =~ "Show Ticket"
      assert html =~ ticket.priority
    end

    test "updates ticket within modal", %{conn: conn, ticket: ticket} do
      {:ok, show_live, _html} = live(conn, ~p"/customer/tickets/#{ticket}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Ticket"

      assert_patch(show_live, ~p"/customer/tickets/#{ticket}/show/edit")

      assert show_live
             |> form("#ticket-form", ticket: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#ticket-form", ticket: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/customer/tickets/#{ticket}")

      html = render(show_live)
      assert html =~ "Ticket updated successfully"
      assert html =~ "some updated priority"
    end
  end
end
