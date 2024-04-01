defmodule SnowPortal.Tickets.TicketHistory do
  alias SnowPortal.Tickets.Ticket
  alias SnowPortal.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  @status_values ~w/CREATED ASSIGNED HOLD CLOSED/a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_history" do
    field :ticket_status, Ecto.Enum, values: @status_values, default: :CREATED, null: false

    belongs_to :ticket, Ticket
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(ticket_history, attrs) do
    IO.inspect(ticket_history, label: "ticket_history ***** ")
    IO.inspect(attrs, label: "attrs ***** ")

    ticket_history
    |> cast(attrs, [:ticket_id, :user_id, :ticket_status])
    |> validate_required([:ticket_status])
  end
end
