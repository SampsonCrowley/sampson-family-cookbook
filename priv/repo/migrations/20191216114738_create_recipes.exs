defmodule SampsonCookbook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :citext, null: false
      add :est_time, :integer
      add :tags, {:array, :citext}

      timestamps()
    end

    create index(:recipes, [:name])
    create index(:recipes, [:tags], using: "GIN")
  end

end
