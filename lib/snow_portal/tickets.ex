defmodule SnowPortal.Tickets do
  @moduledoc """
  The Tickets context.
  """

  import Ecto.Query, warn: false
  alias SnowPortal.Repo

  alias SnowPortal.Tickets.Ticket

  @doc """
  Returns the list of tickets.

  ## Examples

      iex> list_tickets()
      [%Ticket{}, ...]

  """
  def list_tickets do
    Repo.all(Ticket)
    |> Repo.preload([:ticket_attachments, :created_by_user, :assigned_to_user])
  end

  @doc """
  Returns the list of tickets assigned to specific user.

  ## Examples

      iex> list_tickets_by_user(id)
      [%Ticket{}, ...]

  """
  def list_tickets_by_user(id) do
    Ticket
    |> where([t], t.assigned_to_user_id == ^id)
    |> Repo.all()
    |> Repo.preload([:ticket_attachments, :created_by_user, :assigned_to_user])
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id),
    do:
      Repo.get!(Ticket, id)
      |> Repo.preload([:ticket_attachments, :created_by_user, :assigned_to_user])

  @doc """
  Creates a ticket.

  ## Examples

      iex> create_ticket(%{field: value})
      {:ok, %Ticket{}}

      iex> create_ticket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket(attrs \\ %{}) do
    %Ticket{}
    |> Ticket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end

  def list_user_role_types, do: Ecto.Enum.values(Ticket, :type)

  def list_ticket_priority_types, do: Ecto.Enum.values(Ticket, :priority)

  def create_images(ticket_id, images) do
    ticket_id
    |> get_ticket!()
    |> Repo.preload([:ticket_attachments])
    |> Ticket.changeset(%{ticket_attachments: images})
    |> Repo.update()
  end
end
