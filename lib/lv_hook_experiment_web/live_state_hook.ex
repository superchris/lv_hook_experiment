defmodule LvHookExperimentWeb.LiveStateHook do
  alias Phoenix.PubSub
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, params, session, %{id: socket_id} = socket) do
    IO.inspect(socket, label: "socket")
    PubSub.subscribe(LvHookExperiment.PubSub, "live_state:events:#{socket_id}")
    {:cont, socket |> attach_hook(:live_state, :after_render, &sync_live_state/1)}
  end

  def sync_live_state(%{assigns: assigns, id: socket_id} = socket) do
    PubSub.broadcast(LvHookExperiment.PubSub, "live_state:state:#{socket_id}", {:after_render, assigns})
    socket
  end
end
