defmodule SnowPortal.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE types AS ENUM ('INCIDENT', 'SERVICE_REQUEST', 'CHANGE_REQUEST')"
    drop_query = "DROP TYPE types"

    create_priority_query =
      "CREATE TYPE priority_types AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')"

    drop_priority_query = "DROP TYPE priority_types"

    execute(create_query, drop_query)
    execute(create_priority_query, drop_priority_query)

    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :types, default: "INCIDENT", null: false
      add :title, :string
      add :description, :string
      add :priority, :priority_types, default: "LOW", null: false
      add :attachments, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:tickets, [:user_id])
  end
end
