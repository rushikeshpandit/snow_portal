defmodule SnowPortal.Tickets.TicketComments do
  alias SnowPortal.Tickets.Ticket
  alias SnowPortal.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_comments" do
    field :comment, :string

    belongs_to :ticket, Ticket
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket_comments, attrs) do
    IO.inspect(ticket_comments, label: "ticket_comments ***** ")
    IO.inspect(attrs, label: "attrs ***** ")

    ticket_comments
    |> cast(attrs, [:ticket_id, :user_id, :comment])
    |> validate_required([:comment])
  end
end
