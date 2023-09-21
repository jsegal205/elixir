defmodule LinkShortener.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :key, :string
    field :url, :string
    field :hit_counter, :integer

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:key, :url, :hit_counter])
    |> validate_required([:key, :url, :hit_counter])
    |> unique_constraint(:url)
    |> unique_constraint(:key)
  end
end
