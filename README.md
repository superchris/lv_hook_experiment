# Live View/Live State sync POC

This is a POC of an approach to allow non LV front ends to receive and keep in sync with state from a LiveView. I've used a custom element as it's easy and convenient, but this would be no more difficult to do from React (or JS framework du jour).

In a nutshell, my approach is to leverage LiveState, which already sends state updates as json patches and can work with any JS client (web components, React, Preact, etc). To keep in sync with a LiveView, I attach an `:after_render` hook in the LiveView and pubsub the assigns to a topic which includes the socket id:

```elixir
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
```

 On the front end, I set the socket id as attribute to a custom element, which then attaches to LiveState channel whose only job is to receive the assigns from the LiveView over the pubsub channel:

```elixir
defmodule LvHookExperimentWeb.LiveViewSyncChannel do
  @moduledoc false
  alias Phoenix.PubSub

  use LiveState.Channel, web_module: LvHookExperimentWeb

  @impl true
  def init(_channel, %{"socket_id" => lv_socket_id}, socket) do
    PubSub.subscribe(LvHookExperiment.PubSub, "live_state:state:#{lv_socket_id}")
    {:ok, %{people: [], lv_socket_id: lv_socket_id}, socket |> assign(:lv_socket_id, lv_socket_id)}
  end

  @impl true
  def handle_message({:after_render, assigns}, state) do
    {:noreply, assigns}
  end

  @impl true
  def handle_event(event, payload, state, %{assigns: %{lv_socket_id: lv_socket_id}} = socket) do
    PubSub.broadcast(LvHookExperiment.PubSub, "live_state:events:#{lv_socket_id}", {:live_state, event, payload})
    {:noreply, state}
  end
end
```

 Sending events back into LV from the front end client right now is a little clunky, as it comes in as `handle_info` but I think this is a problem that could be solved. In any event, for a quick POC I was pleased with the end result:

https://www.loom.com/share/37be1d32e8114fe9b1ec3cff3f398305?sid=978a74b5-3372-4c24-8f00-19895a847c05
