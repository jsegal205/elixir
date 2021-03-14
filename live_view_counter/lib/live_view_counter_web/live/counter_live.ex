defmodule LiveViewCounterWeb.CounterLive do
  use Phoenix.LiveView

  alias LiveViewCounterWeb.{Endpoint, Counter}

  @topic "counter"

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html?#c:mount/3
  def mount(_params, _session, socket) do
    Endpoint.subscribe(@topic)
    count = Counter.lookup()

    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#assign/3
    {:ok, assign(socket, :count, count)}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("add", _, socket) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    new_count = update(socket, :count, &(&1 + 1))

    # tell everyone listening to this port to update the value
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "add", new_count.assigns)
    # update genserver memory data store
    LiveViewCounterWeb.Counter.update(new_count.assigns.count)

    {:noreply, new_count}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("subtract", _, socket) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    new_count = update(socket, :count, &(&1 - 1))

    # tell everyone listening to this port to update the value
    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "subtract", new_count.assigns)
    # update genserver memory data store
    LiveViewCounterWeb.Counter.update(new_count.assigns.count)

    {:noreply, new_count}
  end

  def handle_event("reset", _, socket) do
    new_count = update(socket, :count, fn _ -> 0 end)

    LiveViewCounterWeb.Endpoint.broadcast_from(self(), @topic, "reset", new_count.assigns)
    LiveViewCounterWeb.Counter.update(new_count.assigns.count)

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
      <button phx-click="reset">Reset to Zero</button>
    </div>
    """
  end
end
