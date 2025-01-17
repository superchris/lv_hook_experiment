defmodule LvHookExperimentWeb.PeopleChannel do
  @moduledoc false
  alias Phoenix.PubSub

  use LiveState.Channel, web_module: LvHookExperimentWeb

  @impl true
  def init(_channel, %{"socket_id" => lv_socket_id}, socket) do
    PubSub.subscribe(LvHookExperiment.PubSub, "live_state:state:#{lv_socket_id}")
    {:ok, %{people: [], lv_socket_id: lv_socket_id}, socket |> assign(:lv_socket_id, lv_socket_id)}
  end

  @impl true
  def handle_event("do_something", _payload, state) do
    {:noreply, Map.put(state, :foo, "bar")}
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
