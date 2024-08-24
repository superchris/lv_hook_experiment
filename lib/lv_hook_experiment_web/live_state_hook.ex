defmodule LvHookExperimentWeb.LiveStateHook do
  alias Phoenix.PubSub
  import Phoenix.LiveView
  import Phoenix.Component

  def on_mount(:default, params, sesion, socket) do
    PubSub.subscribe(LvHookExperiment.PubSub, "live_state:events")
    {:cont, socket |> attach_hook(:live_state, :after_render, &sync_live_state/1)}
  end

  def sync_live_state(%{assigns: assigns} = socket) do
    PubSub.broadcast(LvHookExperiment.PubSub, "live_state", {:after_render, assigns})
    socket
  end
end
