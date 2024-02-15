defmodule SnowPortal.Repo do
  use Ecto.Repo,
    otp_app: :snow_portal,
    adapter: Ecto.Adapters.Postgres
end
