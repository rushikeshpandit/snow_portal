defmodule SnowPortal.Repo.Migrations.CreateUserTicket do
  use Ecto.Migration

  def change do
    alter table(:users, primary_key: false) do
      add :ticket_id,
          references(:tickets, on_delete: :delete_all, on_update: :update_all, type: :binary_id)
    end
  end
end
