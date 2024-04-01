defmodule SnowPortal.Repo.Migrations.CreateTicketAttachments do
  use Ecto.Migration

  def change do
    create table(:ticket_attachments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :image_url, :string

      add :ticket_id,
          references(:tickets, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      add :user_id,
          references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:ticket_attachments, [:ticket_id])
    create index(:ticket_attachments, [:user_id])
  end
end
