defmodule LvHookExperimentWeb.PeopleChannel do
  @moduledoc false
  alias Phoenix.PubSub

  use LiveState.Channel, web_module: LvHookExperimentWeb

  @impl true
  def init(_channel, _params, _socket) do
    PubSub.subscribe(LvHookExperiment.PubSub, "live_state")
    {:ok, %{people: []}}
  end

  @impl true
  def handle_event("do_something", _payload, state) do
    {:noreply, Map.put(state, :foo, "bar")}
  end

  def handle_message({:after_render, assigns}, state) do
    {:noreply, assigns}
  end

  def handle_event(event, payload, state) do
    PubSub.broadcast(LvHookExperiment.PubSub, "live_state:events", {:live_state, event, payload})
    {:noreply, state}
  end
end
