defmodule LvHookExperimentWeb.TodoChannel do
  @moduledoc false

  use LiveState.Channel, web_module: LvHookExperimentWeb

  @impl true
  def init(_channel, _params, _socket) do
    {:ok, %{people: []}}
  end

  @impl true
  def handle_event("do_something", _payload, state) do
    {:noreply, Map.put(state, :foo, "bar")}
  end

end
