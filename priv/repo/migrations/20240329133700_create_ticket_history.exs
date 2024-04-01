defmodule SnowPortal.Repo.Migrations.CreateTicketHistory do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE ticket_status AS ENUM ('CREATED', 'ASSIGNED', 'HOLD' ,'CLOSED')"
    drop_query = "DROP TYPE ticket_status"

    execute(create_query, drop_query)

    create table(:ticket_history, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :ticket_status, :ticket_status, default: "CREATED", null: false

      add :ticket_id,
          references(:tickets, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      add :user_id,
          references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:ticket_history, [:ticket_id])
    create index(:ticket_history, [:user_id])
  end
end
