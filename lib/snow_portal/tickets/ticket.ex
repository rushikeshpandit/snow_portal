defmodule SnowPortal.Tickets.Ticket do
  use Ecto.Schema
  import Ecto.Changeset

  @type_values ~w/INCIDENT SERVICE_REQUEST CHANGE_REQUEST/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tickets" do
    field :priority, :string
    field :type, Ecto.Enum, values: @type_values, default: :INCIDENT
    field :description, :string
    field :title, :string
    field :attachments, :string
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:type, :title, :description, :priority, :attachments])
    |> validate_required([:type, :title, :description, :priority, :attachments])
  end
end
