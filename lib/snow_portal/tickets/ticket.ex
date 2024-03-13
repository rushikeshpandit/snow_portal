defmodule SnowPortal.Tickets.Ticket do
  alias SnowPortal.Accounts.User
  alias SnowPortal.TicketImages
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

    belongs_to :user, User
    has_many :attachments, TicketImages, on_replace: :delete_if_exists, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:type, :title, :description, :priority])
    |> validate_required([:type, :title, :description, :priority])
    |> cast_assoc(:attachments, with: &TicketImages.changeset/2)
  end
end
