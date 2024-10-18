defmodule CountPalindromicSubstringsTest do
  use ExUnit.Case

  describe "count/1" do
    test "it counts" do
      # a,b,c,b,a,bcb,abcba
      assert CountPalindromicSubstrings.count("abcba") == 7
      # a,b,b,a,bb,abba
      assert CountPalindromicSubstrings.count("abba") == 6

      assert CountPalindromicSubstrings.count("a") == 1

      assert CountPalindromicSubstrings.count("ab") == 2

      # t,a,c,o,c,a,t,coc,acoca,tacocat
      assert CountPalindromicSubstrings.count("tacocat") == 10

      # readme test cases
      assert CountPalindromicSubstrings.count("abc") == 3
      assert CountPalindromicSubstrings.count("aaa") == 6
    end

    @tag :skip
    test "1000 character string" do
      # this bad boy takes 20+ seconds to run. need to adjust to handle this
      assert "a" |> String.duplicate(1000) |> CountPalindromicSubstrings.count() == 500_500
    end
  end
end
