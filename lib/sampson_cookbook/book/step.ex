defmodule SampsonCookbook.Book.Step do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Book
  alias SampsonCookbook.Book.Step

  schema "steps" do
    field :details, :string
    field :order, :integer
    field :delete, :boolean, virtual: true
    belongs_to :recipe, Book.Recipe

    timestamps()
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:details, :order])
    |> validate_required([:details, :order])
  end

  @doc false
  def update_changeset(%Step{recipe_id: nil}, attrs, recipe) do
    Ecto.build_assoc(recipe, :steps)
    |> cast(attrs, [:details, :order, :recipe_id])
    |> validate_required([:details, :order, :recipe_id])
  end

  @doc false
  def update_changeset(%Step{} = step, attrs, _recipe) do
    step
    |> cast(attrs, [:details, :order, :recipe_id, :delete])
    |> validate_required([:details, :order, :recipe_id])
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
