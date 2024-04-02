defmodule SnowPortal.Tickets.Ticket do
  alias SnowPortal.Tickets.TicketHistory
  alias SnowPortal.Tickets.TicketComments
  alias SnowPortal.Accounts.User
  alias SnowPortal.Tickets.TicketAttachments
  use Ecto.Schema
  import Ecto.Changeset

  @type_values ~w/INCIDENT SERVICE_REQUEST CHANGE_REQUEST/a
  @priority_type_values ~w/LOW MEDIUM HIGH CRITICAL/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    field :priority, Ecto.Enum, values: @priority_type_values, default: :LOW
    field :type, Ecto.Enum, values: @type_values, default: :INCIDENT
    field :description, :string
    field :title, :string

    belongs_to :created_by_user, User, foreign_key: :created_by_user_id
    belongs_to :assigned_to_user, User, foreign_key: :assigned_to_user_id

    has_many :ticket_attachments, TicketAttachments,
      on_replace: :delete_if_exists,
      on_delete: :delete_all

    has_many :ticket_comment, TicketComments,
      on_replace: :delete_if_exists,
      on_delete: :delete_all

    has_many :ticket_history, TicketHistory, on_replace: :delete_if_exists, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [
      :type,
      :title,
      :description,
      :priority,
      :created_by_user_id,
      :assigned_to_user_id
    ])
    |> validate_required([
      :type,
      :title,
      :description,
      :priority,
      :created_by_user_id
    ])
    |> cast_assoc(:ticket_attachments, with: &TicketAttachments.changeset/2)
  end
end
