defmodule SampsonCookbook.Book.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Book
  alias SampsonCookbook.Book.Recipe

  schema "recipes" do
    field :est_time, :integer, default: 0
    field :name, :string
    field :tags, {:array, :string}
    has_many :ingredients, Book.Ingredient
    has_many :steps, Book.Step

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :est_time, :tags])
    |> validate_required([:name, :est_time, :tags])
    |> cast_assoc(:ingredients)
    |> cast_assoc(:steps)
  end

  @doc false
  def update_changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :est_time, :tags])
    |> validate_required([:name, :est_time, :tags])
    |> cast_assoc(:ingredients, with: &Book.Ingredient.update_changeset(&1, &2, recipe))
    |> cast_assoc(:steps, with: &Book.Step.update_changeset(&1, &2, recipe))
  end
end
