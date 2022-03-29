defmodule MapCompare do
  @moduledoc """
  You have 2 maps. You are looking for the difference between the 2. What was added or removed or if the map is the same.

  Map only have string keys
  Map only have string, boolean, number, list or map as value
  Compare should have an option for deep or shallow compare
  Compare should list the difference for keys and values
  """

  def compare(a, b) when not is_map(a) or not is_map(b) do
    {:error, "Invalid arg type. Only accepts Maps as args."}
  end

  def compare(a, a) do
    %{same: true}
  end

  # get all keys from a, get all keys from b, compare
end
