defmodule GildedRoseTest do
  use ExUnit.Case
  doctest GildedRose

  alias GildedRose
  alias GildedRose.Item

  test "interface specification" do
    gilded_rose = GildedRose.new()
    [%Item{} | _] = GildedRose.items(gilded_rose)
    assert :ok == GildedRose.update_quality(gilded_rose)
  end

  describe "update_quantity/1" do
    setup do
      agent = GildedRose.new()
      items = GildedRose.items(agent)
      [agent: agent, items: items]
    end

    test "quality decrease by 2 when sell_in below 0", %{agent: agent} do
      %Item{name: name} = expired_elixir = Item.new("Elixir of the Mongoose", -1, 50)

      update_item(agent, name, expired_elixir)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 48
    end

    test "aged brie increases in quality as sell_in decreases", %{agent: agent} do
      %Item{quality: before_quality} =
        get_item_by_name(agent, "Aged Brie")

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, "Aged Brie")

      assert before_quality < after_quality
    end

    test "aged brie quality never goes over 50", %{agent: agent} do
      %Item{name: name} = high_quality_brie = Item.new("Aged Brie", 2, 50)

      update_item(agent, name, high_quality_brie)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 50
    end

    test "sulfuras never decreases in quality", %{agent: agent} do
      %Item{quality: before_quality} =
        get_item_by_name(agent, "Sulfuras, Hand of Ragnaros")

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, "Sulfuras, Hand of Ragnaros")

      assert before_quality == after_quality
    end

    test "sulfuras never has to be sold", %{agent: agent} do
      %Item{sell_in: 0 = before_sell_in} =
        get_item_by_name(agent, "Sulfuras, Hand of Ragnaros")

      GildedRose.update_quality(agent)

      %Item{sell_in: 0 = after_sell_in} =
        get_item_by_name(agent, "Sulfuras, Hand of Ragnaros")

      assert before_sell_in == after_sell_in
    end

    test "backstage passes quality increase by 1 when sell_in > 10", %{agent: agent} do
      name = "Backstage passes to a TAFKAL80ETC concert"

      %Item{quality: before_quality} =
        get_item_by_name(agent, name)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert before_quality < after_quality
    end

    test "backstage passes quality increase by 2 when sell_in <= 10", %{agent: agent} do
      %Item{name: name} =
        backstage_pass = Item.new("Backstage passes to a TAFKAL80ETC concert", 6, 1)

      update_item(agent, name, backstage_pass)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 3
    end

    test "backstage passes quality set to 0 when sell_in < 0", %{agent: agent} do
      %Item{name: name} =
        backstage_pass = Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 10)

      update_item(agent, name, backstage_pass)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 0
    end

    test "backstage passes increase by 3 when sell_in >= 5", %{agent: agent} do
      %Item{name: name} =
        backstage_pass = Item.new("Backstage passes to a TAFKAL80ETC concert", 1, 1)

      update_item(agent, name, backstage_pass)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 4
    end

    test "backstage passes quality never goes over 50", %{agent: agent} do
      %Item{name: name} =
        backstage_pass = Item.new("Backstage passes to a TAFKAL80ETC concert", 2, 50)

      update_item(agent, name, backstage_pass)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 50
    end

    test "conjured items quality degrades twice as fast when sell_in >= 0", %{agent: agent} do
      %Item{name: name} =
        conjured_cake = Item.new("Conjured Mana Cake", 0, 10)

      update_item(agent, name, conjured_cake)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 8
    end

    test "conjured items quality degrades twice as fast when sell_in < 0", %{agent: agent} do
      %Item{name: name} =
        conjured_cake = Item.new("Conjured Mana Cake", -1, 10)

      update_item(agent, name, conjured_cake)

      GildedRose.update_quality(agent)

      %Item{quality: after_quality} =
        get_item_by_name(agent, name)

      assert after_quality == 6
    end
  end

  defp get_item_by_name(agent, name) do
    agent
    |> GildedRose.items()
    |> Enum.find(fn %Item{} = item -> item.name == name end)
  end

  defp update_item(agent, name, updated_item) do
    idx =
      agent
      |> GildedRose.items()
      |> Enum.find_index(fn %Item{} = item -> item.name == name end)

    Agent.update(agent, &List.replace_at(&1, idx, updated_item))
  end
end
