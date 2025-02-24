defmodule Drawing.Presence do
  use Phoenix.Presence,
    otp_app: :drawing,
    pubsub_server: Drawing.PubSub

  alias Drawing.Presence

  def track_presence(pid, topic, key, payload) do
    Presence.track(pid, topic, key, payload)
  end

  def untrack_presence(pid, topic, key) do
    Presence.untrack(pid, topic, key)
  end

  def update_presence(pid, topic, key, payload) do
    metas =
      Presence.get_by_key(topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(pid, topic, key, metas)
  end

  def list_presences(topic) do
    Presence.list(topic)
    |> Enum.map(fn {_user_id, data} ->
      data[:metas]
      |> List.first()
    end)
  end
end
