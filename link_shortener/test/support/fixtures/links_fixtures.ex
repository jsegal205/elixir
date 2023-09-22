defmodule LinkShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkShortener.Links` context.
  """

  @doc """
  Generate a unique link url.
  """
  def unique_link_url, do: "http://example#{System.unique_integer([:positive])}.com"

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        "url" => unique_link_url(),
        "hit_counter" => 42
      })
      |> LinkShortener.Links.create_link()

    link
  end
end
