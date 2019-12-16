defmodule SampsonCookbook.Book.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Book
  alias SampsonCookbook.Book.Ingredient

  schema "ingredients" do
    field :amount, :string
    field :name, :string
    field :required, :boolean, default: true
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Book.Recipe

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :amount, :required])
    |> validate_required([:name, :amount, :required])
  end

  @doc false
  def update_changeset(%Ingredient{recipe_id: nil}, attrs, recipe) do
    Ecto.build_assoc(recipe, :ingredients)
    |> cast(attrs, [:name, :amount, :required, :recipe_id])
    |> validate_required([:name, :amount, :required, :recipe_id])
  end

  @doc false
  def update_changeset(%Ingredient{} = ingredient, attrs, _recipe) do
    ingredient
    |> cast(attrs, [:name, :amount, :required, :recipe_id, :delete])
    |> validate_required([:name, :amount, :required, :recipe_id])
    |> mark_for_delete()
  end

  @doc false
  defp mark_for_delete(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
