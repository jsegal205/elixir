defmodule LiveViewCounterWeb.CounterLive do
  use Phoenix.LiveView

  @topic "counter"

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html?#c:mount/3
  def mount(_params, _session, socket) do
    LiveViewCounterWeb.Endpoint.subscribe(@topic)

    # When a new process is spawned (new browser is opened or the page is refreshed),
    # this will reset the counter to 0. Thus leading to the reseting the value
    # when new process adds or subtracts. This will continue to count appropriately
    # if existing processes continue to add or subtract.

    # Example
    # -------
    #
    # Browser1 opens
    # :count => 0
    # Browser1 sends "add" event
    # :count => 1
    # Browser2 opens
    # :count => 0
    # Browser2 sends "add" event
    # :count => 1, expected :count => 2

    # I feel like there should be a way to get the value of the current socket on
    # `mount` without the need for a persistence (db) layer.

    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#assign/3
    {:ok, assign(socket, :count, 0)}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("add", _, socket) do
    new_count = update(socket, :count, &(&1 + 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "add", new_count.assigns)
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    {:noreply, new_count}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("subtract", _, socket) do
    new_count = update(socket, :count, &(&1 - 1))
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "subtract", new_count.assigns)

    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    {:noreply, new_count}
  end

  def handle_info(msg, socket) do
    {:noreply, assign(socket, count: msg.payload.count)}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def render(assigns) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Helpers.html#sigil_L/2
    ~L"""
    <div>
      <label> The count is <%= assigns[:count] %></label>
      <button phx-click="add">Add</button>
      <button phx-click="subtract">Subtract</button>
    </div>
    """
  end
end
