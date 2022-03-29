defmodule MapCompare do
  @moduledoc """
  You have 2 maps. You are looking for the difference between the 2. What was added or removed or if the map is the same.

  Map only have string keys
  Map only have string, boolean, number, list or map as value
  Compare should have an option for deep or shallow compare
  Compare should list the difference for keys and values
  """

  # return error if either map_a or map_b is not a map
  def compare(map_a, map_b) when not is_map(map_a) or not is_map(map_b) do
    {:error, "Invalid arg type. Only accepts Maps as args."}
  end

  # if map values are the exact same, return true and no changes
  def compare(a, a) do
    %{same: true}
  end

  def compare(map_a, map_b) do
    # loop through and compare all key value pairs in map_a with map_b
    {changes, equal?} = Enum.reduce(map_a, {%{}, true}, &do_compare(&1, &2, map_b))

    # loop through and note any keys that were added to map_b
    {changes, equal?} = additions(map_a, map_b, changes, equal?)

    if equal? do
      %{same: true}
    else
      removed = (Map.to_list(map_a) -- Map.to_list(map_b)) |> Enum.into(%{})
      added = (Map.to_list(map_b) -- Map.to_list(map_a)) |> Enum.into(%{})
      %{same: false, value: changes, removed_from_a: removed, added_to_b: added}
    end
  end

  # check if map_b has key, onward to do_compare/4
  defp do_compare(el = {key, _}, acc, map_b) do
    do_compare(el, acc, map_b[key], Map.has_key?(map_b, key))
  end

  # if map_b has key listed from map_a, and the values are the same,
  # return {changes (with declaration that values are same), equal?}
  defp do_compare({key, val}, {changes, equal?}, val, true) do
    {Map.put(changes, key, %{changed: :equal, value: val}), equal?}
  end

  # if map_b has key listed from map_a, and the values are maps,
  # time to recurse and do it all over again, forever
  defp do_compare({key, vala}, {changes, equal?}, valb, true)
       when is_map(vala) and is_map(valb) do
    valueDiff = compare(vala, valb)

    # return {changes (with this any listed differences), equal?}
    case valueDiff.same do
      true -> {Map.put(changes, key, %{changed: :equal, value: vala}), equal?}
      _ -> {Map.put(changes, key, valueDiff), false}
    end
  end

  # if map_b has key listed in map_a, and the values are not maps,
  # and the values of the key are different,
  # return {changes (with this new value difference), equal?}
  defp do_compare({key, vala}, {changes, _}, valb, true) do
    {Map.put(changes, key, %{changed: :value_changed, removed: vala, added: valb}), false}
  end

  # if map_b does not have the key from map_a,
  # return {changes (with this new key difference), equal?}
  defp do_compare({key, vala}, {changes, _}, _, false) do
    {Map.put(changes, key, %{changed: :key_removed, value: vala}), false}
  end

  # Iterates over all new keys in `b` that were not in `a`, and returns their values
  # in the proper format.
  defp additions(a, b, changes, equal?) do
    Enum.reduce(Map.keys(b) -- Map.keys(a), {changes, equal?}, fn key, {changes, _equal?} ->
      {Map.put(changes, key, %{changed: :key_added, value: b[key]}), false}
    end)
  end
end
