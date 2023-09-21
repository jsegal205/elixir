defmodule LinkShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :key, :string
      add :url, :string
      add :hit_counter, :integer

      timestamps()
    end

    create unique_index(:links, [:url])
    create unique_index(:links, [:key])
  end
end
