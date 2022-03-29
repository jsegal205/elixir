defmodule MapCompareTest do
  use ExUnit.Case

  test "when both args are not maps" do
    expected = {:error, "Invalid arg type. Only accepts Maps as args."}
    assert MapCompare.compare(1, 1) == expected
    assert MapCompare.compare(1, "two") == expected
    assert MapCompare.compare(1, true) == expected
    assert MapCompare.compare(1, []) == expected
    assert MapCompare.compare(1, %{}) == expected
    assert MapCompare.compare("one", 1) == expected
    assert MapCompare.compare("one", "two") == expected
    assert MapCompare.compare("one", true) == expected
    assert MapCompare.compare("one", []) == expected
    assert MapCompare.compare("one", %{}) == expected
    assert MapCompare.compare(false, 1) == expected
    assert MapCompare.compare(false, "two") == expected
    assert MapCompare.compare(false, true) == expected
    assert MapCompare.compare(false, []) == expected
    assert MapCompare.compare(false, %{}) == expected
    assert MapCompare.compare([], 1) == expected
    assert MapCompare.compare([], "two") == expected
    assert MapCompare.compare([], true) == expected
    assert MapCompare.compare([], []) == expected
    assert MapCompare.compare([], %{}) == expected
    assert MapCompare.compare(%{}, 1) == expected
    assert MapCompare.compare(%{}, "two") == expected
    assert MapCompare.compare(%{}, true) == expected
    assert MapCompare.compare(%{}, []) == expected

    refute MapCompare.compare(%{}, %{}) == expected
  end

  test "when two empty maps passed" do
    assert MapCompare.compare(%{}, %{}) == %{same: true}
  end

  test "when two maps with same key value pairs" do
    map_a = %{"integer" => 1, "string" => "two", "boolean" => false, "list" => [], "map" => %{}}
    assert MapCompare.compare(map_a, map_a) == %{same: true}
  end

  test "when two maps with different keys but same values" do
    assert MapCompare.compare(%{"a" => 1}, %{"b" => 1}) == %{
             same: false,
             added_to_b: %{"b" => 1},
             removed_from_a: %{"a" => 1}
           }
  end

  test "when two maps with same keys but different values" do
    assert MapCompare.compare(%{"a" => 1}, %{"a" => 2}) == %{
             same: false,
             added_to_b: %{"b" => 1},
             removed_from_a: %{"a" => 1}
           }
  end
end
