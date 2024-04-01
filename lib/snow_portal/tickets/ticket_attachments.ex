defmodule SnowPortal.Tickets.TicketAttachments do
  alias SnowPortal.Accounts.User
  alias SnowPortal.Tickets.Ticket
  alias SnowPortal.TicketPhoto
  use Ecto.Schema
  import Ecto.Changeset
  import Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticket_attachments" do
    field :image_url, TicketPhoto.Type
    belongs_to :ticket, Ticket
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket_attachments, attrs) do
    ticket_attachments
    |> cast(attrs, [:ticket_id, :user_id])
    |> cast_attachments(attrs, [:image_url], allow_paths: true)
  end
end
