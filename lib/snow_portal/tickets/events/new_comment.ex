defmodule SnowPortal.NewComment do
  alias Phoenix.PubSub
  @pubsub SnowPortal.PubSub
  @new_comment "new_comment"
  @update_comment "update_comment"

  def subscribe_new_comment do
    PubSub.subscribe(@pubsub, @new_comment)
  end

  def broadcast_new_comment({:error, _} = err), do: err

  def broadcast_new_comment({:ok, comment} = result) do
    PubSub.broadcast(@pubsub, @new_comment, {:new_comment, comment})
    result
  end

  def subscribe_update_comment, do: PubSub.subscribe(@pubsub, @update_comment)

  def broadcast_update_comment({:error, _} = err), do: err

  def broadcast_update_comment({:ok, comment} = result) do
    PubSub.broadcast(@pubsub, @update_comment, {:update_comment, comment})
    result
  end
end
