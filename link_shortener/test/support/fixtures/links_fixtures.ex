defmodule LinkShortener.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LinkShortener.Links` context.
  """

  @doc """
  Generate a unique link key.
  """
  def unique_link_key, do: "some key#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique link url.
  """
  def unique_link_url, do: "some url#{System.unique_integer([:positive])}"

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        key: unique_link_key(),
        url: unique_link_url(),
        hit_counter: 42
      })
      |> LinkShortener.Links.create_link()

    link
  end
end
