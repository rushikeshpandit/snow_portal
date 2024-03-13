defmodule SnowPortal.TicketImages do
  alias SnowPortal.TicketPhoto
  use Ecto.Schema
  import Ecto.Changeset
  import Waffle.Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ticketimage" do
    field :image_url, TicketPhoto.Type
    field :ticket_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket_images, attrs) do
    ticket_images
    |> cast(attrs, [:ticket_id, :user_id])
    |> cast_attachments(attrs, [:image_url])
  end
end
