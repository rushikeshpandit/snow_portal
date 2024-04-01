defmodule SnowPortal.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SnowPortal.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        ticket_attachments: "some attachments",
        description: "some description",
        priority: "some priority",
        title: "some title",
        type: "INCIDENT"
      })
      |> SnowPortal.Tickets.create_ticket()

    ticket
  end
end
