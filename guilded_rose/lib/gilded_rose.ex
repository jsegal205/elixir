defmodule GildedRose do
  use Agent
  alias GildedRose.Item

  @base_item_quality_adjustment 1

  def new() do
    {:ok, agent} =
      Agent.start_link(fn ->
        [
          Item.new("+5 Dexterity Vest", 10, 20),
          Item.new("Aged Brie", 2, 0),
          Item.new("Elixir of the Mongoose", 5, 7),
          Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
          Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
          Item.new("Conjured Mana Cake", 3, 6)
        ]
      end)

    agent
  end

  def items(agent), do: Agent.get(agent, & &1)

  def update_quality(agent) do
    Agent.update(
      agent,
      &Enum.map(&1, fn %Item{} = item ->
        item
        |> adjust_quality()
        |> adjust_sell_in()
      end)
    )
  end

  defp adjust_sell_in(%Item{name: "Sulfuras, Hand of Ragnaros"} = item), do: item
  defp adjust_sell_in(%Item{} = item), do: %{item | sell_in: item.sell_in - 1}

  defp adjust_quality(%Item{name: name} = item) do
    case name do
      "Sulfuras, Hand of Ragnaros" ->
        item

      "Aged Brie" ->
        adjust_brie(item)

      "Backstage passes to a TAFKAL80ETC concert" ->
        adjust_backstage(item)

      "Conjured" <> _ ->
        adjust_conjured(item)

      _ ->
        base_adjustment(item)
    end
  end

  defp adjust_brie(item) do
    apply_new_quality(item, @base_item_quality_adjustment, :add)
  end

  defp adjust_backstage(%Item{sell_in: sell_in} = item) when sell_in < 0,
    do: apply_new_quality(item, 0, :override)

  defp adjust_backstage(%Item{sell_in: sell_in} = item) do
    adjustment =
      cond do
        sell_in < 5 ->
          @base_item_quality_adjustment * 3

        sell_in < 10 ->
          @base_item_quality_adjustment * 2

        true ->
          @base_item_quality_adjustment
      end

    apply_new_quality(item, adjustment, :add)
  end

  defp adjust_conjured(%Item{} = item) do
    adjustment = default_adjustment(item) * 2

    apply_new_quality(item, adjustment)
  end

  defp base_adjustment(%Item{} = item) do
    adjustment = default_adjustment(item)

    apply_new_quality(item, adjustment)
  end

  defp default_adjustment(%Item{sell_in: sell_in} = _item) when sell_in < 0,
    do: @base_item_quality_adjustment * 2

  defp default_adjustment(_), do: @base_item_quality_adjustment

  defp max_quality(quality) when quality >= 50, do: 50
  defp max_quality(quality), do: quality

  defp apply_new_quality(item, new_quality, operator \\ :subtract)

  defp apply_new_quality(item, new_quality, :override),
    do: %{item | quality: max_quality(new_quality)}

  defp apply_new_quality(item, new_quality, :add),
    do: %{item | quality: max_quality(item.quality + new_quality)}

  defp apply_new_quality(item, new_quality, :subtract),
    do: %{item | quality: item.quality - new_quality}
end
