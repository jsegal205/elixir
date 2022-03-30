defmodule MapSanitize do
  @moduledoc """
  A library for sanitizing potentially sensitive data that may be passed in as a source
  """

  @scrub_atom_keys [:name, :password, :username]
  @scrub_string_keys ["name", "password", "username"]
  @replace "********"

  def scrub(input) when not is_map(input), do: input

  def scrub(input), do: do_scrub(input)

  defp do_scrub(map, sanitized_input \\ %{}) do
    Enum.reduce(map, sanitized_input, &scrub_map(&1, &2))
  end

  defp scrub_map({key, val}, sanitized_input) when is_list(val) do
    Map.put(sanitized_input, key, Enum.map(val, &do_scrub(&1)))
  end

  defp scrub_map({key, val}, sanitized_input) when is_map(val) do
    Map.put(sanitized_input, key, do_scrub(val, sanitized_input))
  end

  defp scrub_map({key, _}, sanitized_input)
       when key in @scrub_atom_keys or key in @scrub_string_keys do
    Map.put(sanitized_input, key, @replace)
  end

  defp scrub_map({key, val}, sanitized_input) when key in [:email, "email"] do
    # .+?(?=@) matches everything before given @ symbol
    Map.put(sanitized_input, key, String.replace(val, ~r/.+?(?=@)/, @replace))
  end

  defp scrub_map({key, val}, sanitized_input) do
    Map.put(sanitized_input, key, val)
  end
end
