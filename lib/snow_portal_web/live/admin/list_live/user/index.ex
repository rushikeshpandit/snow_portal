defmodule SnowPortalWeb.Admin.ListLive.User.Index do
  use SnowPortalWeb, :live_view
  alias SnowPortal.Accounts
  alias SnowPortalWeb.Admin.ListLive.ListRow

  def mount(_params, _session, socket),
    do: {:ok, socket |> assign(users: Accounts.list_users_by_role(role: :USER))}
end
