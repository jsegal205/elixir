defmodule LiveViewCounterWeb.CounterLive do
  use Phoenix.LiveView

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html?#c:mount/3
  def mount(_params, _session, socket) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#assign/3
    {:ok, assign(socket, :count, 0)}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("add", _, socket) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    {:noreply, update(socket, :count, &(&1 + 1))}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_event/3
  def handle_event("subtract", _, socket) do
    # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#update/3
    # https://dockyard.com/blog/2016/08/05/understand-capture-operator-in-elixir
    {:noreply, update(socket, :count, &(&1 - 1))}
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
