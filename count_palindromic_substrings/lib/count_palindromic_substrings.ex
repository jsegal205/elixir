defmodule CountPalindromicSubstrings do
  @moduledoc """
  Documentation for `CountPalindromicSubstrings`.
  """

  def count(s) do
    total_count = 0

    total_count =
      Enum.reduce(0..(String.length(s) - 1), total_count, fn i, acc ->
        # Check for odd-length palindromes (center is at i)
        # ex `aba`
        acc = count_palindromes_around_center(s, i, i, acc)

        # Check for even-length palindromes (center is between i and i + 1)
        # ex `abba`
        acc = count_palindromes_around_center(s, i, i + 1, acc)
        acc
      end)

    total_count
  end

  defp count_palindromes_around_center(s, left, right, count) do
    if left >= 0 and right < String.length(s) and
         String.at(s, left) == String.at(s, right) do
      # Increment count by 1, as this is a palindrome

      count = count + 1
      # Expand outward
      count_palindromes_around_center(s, left - 1, right + 1, count)
    else
      count
    end
  end
end
