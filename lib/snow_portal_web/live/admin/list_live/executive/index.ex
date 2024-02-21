defmodule SnowPortalWeb.Admin.ListLive.Executive.Index do
  use SnowPortalWeb, :live_view
  alias SnowPortal.Accounts
  alias SnowPortalWeb.Admin.ListLive.ListRow

  def mount(_params, _session, socket) do
    socket = socket |> assign(executives: Accounts.list_users_by_role(role: :EXECUTIVE))

    {:ok, socket}
  end
end
