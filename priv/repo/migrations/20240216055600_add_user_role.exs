defmodule SnowPortal.Repo.Migrations.AddUserRole do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE roles AS ENUM ('USER', 'ADMIN', 'EXECUTIVE')"
    drop_query = "DROP TYPE roles"

    execute(create_query, drop_query)

    alter table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :user_name, :string
      add :role, :roles, default: "USER", null: false
    end

    create unique_index(:users, [:user_name])
  end
end
