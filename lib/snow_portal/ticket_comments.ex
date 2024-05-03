defmodule SnowPortal.TicketComments do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias SnowPortal.Repo

  alias SnowPortal.Tickets.TicketComment

  @doc """
  Returns the list of ticket comments.

  ## Examples

      iex> list_tickets_comments()
      [%TicketComment{}, ...]

  """
  def list_tickets_comments(id) do
    TicketComment
    |> where([tc], tc.ticket_id == ^id)
    |> Repo.all()
    |> Repo.preload([:ticket, :user])
  end

  @doc """
  Creates a ticket comments.

  ## Examples

      iex> create_ticket_comment(%{field: value})
      {:ok, %TicketComment{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket_comment(attrs \\ %{}) do
    %TicketComment{}
    |> TicketComment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket comment.

  ## Examples

      iex> update_ticket_comment(ticket, %{field: new_value})
      {:ok, %TicketComment{}}

      iex> update_ticket_comment(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket_comment(%TicketComment{} = ticket, attrs) do
    ticket
    |> TicketComment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket comment.

  ## Examples

      iex> delete_ticket_comment(ticket)
      {:ok, %TicketComment{}}

      iex> delete_ticket_comment(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket_comment(%TicketComment{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket_comment(ticket)
      %Ecto.Changeset{data: %TicketComment{}}

  """
  def change_ticket_comment(%TicketComment{} = ticket_comment, attrs \\ %{}) do
    TicketComment.changeset(ticket_comment, attrs)
  end
end
