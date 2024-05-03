defmodule SnowPortal.Tickets.TicketComment do
  alias SnowPortal.Tickets.Ticket
  alias SnowPortal.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_comment" do
    field :comment, :string

    belongs_to :ticket, Ticket
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket_comment, attrs) do
    ticket_comment
    |> cast(attrs, [:ticket_id, :user_id, :comment])
    |> validate_required([:comment])
    |> validate_length(:comment, min: 4)
  end
end
