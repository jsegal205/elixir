defmodule LiveViewCounterWeb.CounterLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :count, 23)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <label> The count is <%= assigns[:count] %></label>
    </div>
    """
  end
end
