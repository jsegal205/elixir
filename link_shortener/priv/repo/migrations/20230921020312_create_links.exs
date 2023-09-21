defmodule LinkShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :key, :string
      add :url, :string
      add :hit_counter, :integer, default: 0

      timestamps()
    end

    create unique_index(:links, [:key])
  end
end
