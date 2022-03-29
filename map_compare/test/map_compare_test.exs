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
    map_a = %{
      "integer" => 1,
      "string" => "two",
      "boolean" => false,
      "list" => [],
      "map" => %{}
    }

    map_b = map_a
    assert MapCompare.compare(map_a, map_b) == %{same: true}
  end

  test "when two maps with different keys but same values" do
    assert MapCompare.compare(
             %{"a" => 1},
             %{"b" => 1}
           ) == %{
             same: false,
             added_to_b: %{"b" => 1},
             removed_from_a: %{"a" => 1},
             value: %{
               "a" => %{
                 changed: :key_removed,
                 value: 1
               },
               "b" => %{
                 changed: :key_added,
                 value: 1
               }
             }
           }
  end

  test "when two maps with same keys but different values" do
    assert MapCompare.compare(
             %{
               "integer" => 1,
               "string" => "one",
               "boolean" => true,
               "list" => [1, 2, 3]
             },
             %{
               "integer" => 2,
               "string" => "two",
               "boolean" => false,
               "list" => [4, 5, 6]
             }
           ) == %{
             same: false,
             added_to_b: %{
               "integer" => 2,
               "string" => "two",
               "boolean" => false,
               "list" => [4, 5, 6]
             },
             removed_from_a: %{
               "integer" => 1,
               "string" => "one",
               "boolean" => true,
               "list" => [1, 2, 3]
             },
             value: %{
               "boolean" => %{
                 added: false,
                 changed: :value_changed,
                 removed: true
               },
               "integer" => %{
                 added: 2,
                 changed: :value_changed,
                 removed: 1
               },
               "list" => %{
                 added: [4, 5, 6],
                 changed: :value_changed,
                 removed: [1, 2, 3]
               },
               "string" => %{
                 added: "two",
                 changed: :value_changed,
                 removed: "one"
               }
             }
           }
  end

  test "comparing nested maps" do
    assert MapCompare.compare(
             %{
               "integer" => 1,
               "string" => "two",
               "boolean" => false,
               "list" => [1, 2, 3],
               "map" => %{
                 "integer" => 1,
                 "string" => "two",
                 "boolean" => false,
                 "list" => []
               }
             },
             %{}
           ) == %{
             same: false,
             added_to_b: %{},
             removed_from_a: %{
               "integer" => 1,
               "string" => "two",
               "boolean" => false,
               "list" => [1, 2, 3],
               "map" => %{
                 "integer" => 1,
                 "string" => "two",
                 "boolean" => false,
                 "list" => []
               }
             },
             value: %{
               "integer" => %{
                 changed: :key_removed,
                 value: 1
               },
               "string" => %{
                 changed: :key_removed,
                 value: "two"
               },
               "boolean" => %{
                 changed: :key_removed,
                 value: false
               },
               "list" => %{
                 changed: :key_removed,
                 value: [1, 2, 3]
               },
               "map" => %{
                 changed: :key_removed,
                 value: %{
                   "boolean" => false,
                   "integer" => 1,
                   "list" => [],
                   "string" => "two"
                 }
               }
             }
           }

    assert MapCompare.compare(
             %{},
             %{
               "integer" => 1,
               "string" => "two",
               "boolean" => false,
               "list" => [1, 2, 3],
               "map" => %{
                 "integer" => 1,
                 "string" => "two",
                 "boolean" => false,
                 "list" => []
               }
             }
           ) == %{
             same: false,
             removed_from_a: %{},
             added_to_b: %{
               "integer" => 1,
               "string" => "two",
               "boolean" => false,
               "list" => [1, 2, 3],
               "map" => %{
                 "integer" => 1,
                 "string" => "two",
                 "boolean" => false,
                 "list" => []
               }
             },
             value: %{
               "integer" => %{
                 changed: :key_added,
                 value: 1
               },
               "string" => %{
                 changed: :key_added,
                 value: "two"
               },
               "boolean" => %{
                 changed: :key_added,
                 value: false
               },
               "list" => %{
                 changed: :key_added,
                 value: [1, 2, 3]
               },
               "map" => %{
                 changed: :key_added,
                 value: %{
                   "boolean" => false,
                   "integer" => 1,
                   "list" => [],
                   "string" => "two"
                 }
               }
             }
           }
  end

  test "shallow nested map compare" do
    assert MapCompare.compare(
             %{"map" => %{"integer" => 1}},
             %{"map" => %{"integer" => 2}},
             true
           ) ==
             %{same: true}
  end
end
