defmodule SnowPortal.NewTicket do
  alias Phoenix.PubSub
  @pubsub SnowPortal.PubSub
  @new_ticket "new_ticket"
  @update_ticket "update_ticket"

  def subscribe_new_ticket do
    PubSub.subscribe(@pubsub, @new_ticket)
  end

  def broadcast_new_ticket({:error, _} = err), do: err

  def broadcast_new_ticket({:ok, ticket} = result) do
    PubSub.broadcast(@pubsub, @new_ticket, {:new_ticket, ticket})
    result
  end

  def subscribe_update_ticket, do: PubSub.subscribe(@pubsub, @update_ticket)

  def broadcast_update_ticket({:error, _} = err), do: err

  def broadcast_update_ticket({:ok, ticket} = result) do
    PubSub.broadcast(@pubsub, @update_ticket, {:update_ticket, ticket})
    result
  end
end
