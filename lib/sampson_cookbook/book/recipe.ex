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
    has_many :images, SampsonCookbook.Image

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :est_time, :tags])
    |> validate_required([:name, :est_time, :tags])
    |> normalize_tags()
    |> cast_assoc(:ingredients)
    |> cast_assoc(:steps)
    |> cast_assoc(:images)
  end

  @doc false
  def update_changeset(%Recipe{} = recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :est_time, :tags])
    |> validate_required([:name, :est_time, :tags])
    |> normalize_tags()
    |> cast_assoc(:ingredients, with: &Book.Ingredient.update_changeset(&1, &2, recipe))
    |> cast_assoc(:steps, with: &Book.Step.update_changeset(&1, &2, recipe))
  end

  defp normalize_tags(changeset) do
    case fetch_field(changeset, :tags) do
      {:changes, tags} ->
        cond do
          is_list(tags) ->
            put_change(changeset, :tags, map_tags(tags))
          is_binary(tags) ->
            put_change(changeset, :tags, map_tags([tags]))
          true ->
            put_change(changeset, :tags, [])
        end
      _ ->
        changeset
    end
  end

  defp map_tags(tags), do: Enum.map(tags, fn tag -> normalize_tag(tag) end) |> Enum.uniq_by(fn x -> String.downcase(x) end)

  defp normalize_tag(tag), do: String.replace(tag, ~r/\s+/, "-", global: false)
end
