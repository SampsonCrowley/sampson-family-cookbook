defmodule SampsonCookbook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :text, null: false
      add :est_time, :integer
      add :tags, {:array, :text}

      timestamps()
    end

    create index(:recipes, [:name])
    create index(:recipes, [:tags], using: "GIN")
  end

end
