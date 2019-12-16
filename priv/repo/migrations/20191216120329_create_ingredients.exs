defmodule SampsonCookbook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :string, null: false
      add :amount, :string, null: false
      add :required, :boolean, default: true, null: false
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:ingredients, [:name])
    create index(:ingredients, [:recipe_id])
  end
end
