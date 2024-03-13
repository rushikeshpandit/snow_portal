defmodule SnowPortal.Repo.Migrations.CreateTicketimage do
  use Ecto.Migration

  def change do
    create table(:ticketimage, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :image_url, :string

      add :ticket_id,
          references(:tickets, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      add :user_id,
          references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:ticketimage, [:ticket_id])
    create index(:ticketimage, [:user_id])
  end
end
