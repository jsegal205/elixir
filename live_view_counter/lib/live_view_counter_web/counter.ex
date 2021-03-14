defmodule LiveViewCounterWeb.Counter do
  use GenServer

  # client calls
  def start_link([]) do
    GenServer.start_link(__MODULE__, :empty, name: __MODULE__)
  end

  def update(new_count) do
    GenServer.call(__MODULE__, {:update, new_count})
  end

  def lookup() do
    GenServer.call(__MODULE__, {:lookup})
  end

  # callbacks
  def init(:empty), do: {:ok, %{count: 0}}

  def handle_call({:update, new_count}, _from, index_map) do
    {:reply, :ok, Map.put(index_map, :count, new_count)}
  end

  def handle_call({:lookup}, _from, index_map) do
    {:reply, Map.get(index_map, :count), index_map}
  end
end
