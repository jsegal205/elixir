defmodule MapCompareTest do
  use ExUnit.Case

  test "when both args are not maps" do
    assert MapCompare.compare(1, 1) == {:error, "invalid arg type"}
    assert MapCompare.compare(1, "two") == {:error, "invalid arg type"}
    assert MapCompare.compare(1, true) == {:error, "invalid arg type"}
    assert MapCompare.compare(1, []) == {:error, "invalid arg type"}
    assert MapCompare.compare(1, %{}) == {:error, "invalid arg type"}
    assert MapCompare.compare("one", 1) == {:error, "invalid arg type"}
    assert MapCompare.compare("one", "two") == {:error, "invalid arg type"}
    assert MapCompare.compare("one", true) == {:error, "invalid arg type"}
    assert MapCompare.compare("one", []) == {:error, "invalid arg type"}
    assert MapCompare.compare("one", %{}) == {:error, "invalid arg type"}
    assert MapCompare.compare(false, 1) == {:error, "invalid arg type"}
    assert MapCompare.compare(false, "two") == {:error, "invalid arg type"}
    assert MapCompare.compare(false, true) == {:error, "invalid arg type"}
    assert MapCompare.compare(false, []) == {:error, "invalid arg type"}
    assert MapCompare.compare(false, %{}) == {:error, "invalid arg type"}
    assert MapCompare.compare([], 1) == {:error, "invalid arg type"}
    assert MapCompare.compare([], "two") == {:error, "invalid arg type"}
    assert MapCompare.compare([], true) == {:error, "invalid arg type"}
    assert MapCompare.compare([], []) == {:error, "invalid arg type"}
    assert MapCompare.compare([], %{}) == {:error, "invalid arg type"}
    assert MapCompare.compare(%{}, 1) == {:error, "invalid arg type"}
    assert MapCompare.compare(%{}, "two") == {:error, "invalid arg type"}
    assert MapCompare.compare(%{}, true) == {:error, "invalid arg type"}
    assert MapCompare.compare(%{}, []) == {:error, "invalid arg type"}
  end

  test "when two empty maps passed" do
    assert MapCompare.compare(%{}, %{}) == %{same: true, added_to_b: %{}, removed_from_a: %{}}
  end

  test "when to maps with same key value pairs" do
    map_a = %{"integer" => 1, "string" => "two", "boolean" => false, "list" => [], "map" => %{}}
    assert MapCompare.compare(map_a, map_a) == %{same: true, added_to_b: %{}, removed_from_a: %{}}
  end
end
