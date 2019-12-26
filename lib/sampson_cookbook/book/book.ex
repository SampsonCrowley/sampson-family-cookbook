defmodule SampsonCookbook.Book do
  @moduledoc """
  The Book context.
  """

  import Ecto.Query
  alias SampsonCookbook.Repo
  alias SampsonCookbook.Book.Recipe
  alias SampsonCookbook.Book.Ingredient
  alias SampsonCookbook.Book.Step

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  def find_recipes(search) do
    split = search |> String.split(" ", trim: true)
    like_search = "%#{search}%"

    from(
      r in Recipe,
      where: fragment("? @> ? OR ? LIKE ?", r.tags, ^split, r.name, ^like_search)
    )
    |> Repo.all()
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: get_recipe!(id, false)

  def get_recipe!(id, with_images) do
    query = Repo.get!(Recipe, id)
      |> Repo.preload([ingredients: (from i in Ingredient, order_by: i.id)])
      |> Repo.preload([steps: (from s in Step, order_by: s.order)])
    case with_images do
      true -> query |> Repo.preload(:images)
      _ -> query
    end
  end

  @doc """
  Gets a list of image ids for a recipe.

  ## Examples

      iex> recipe = get_recipe!(123)
      iex> get_recipe_image_ids(recipe)
      [1, 2, 3]

  """
  def get_recipe_image_ids(recipe) do
    recipe_id = try do
      recipe.id
    rescue
      _ -> recipe
    end

    cond do
      is_nil(recipe_id) -> []
      true ->
        from(
          i in SampsonCookbook.Image,
          where: i.recipe_id == ^recipe_id,
          select: i.id,
          order_by: i.id
        )
        |> Repo.all()
    end
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.update_changeset(attrs)
    |> Repo.update()
  end

  def insert_images(%Recipe{} = recipe, attrs, delete_attrs) do
    IO.inspect(attrs)

    Enum.map(
      attrs,
      fn {_, image_attrs} ->
        %SampsonCookbook.Image{}
        |> SampsonCookbook.Image.update_changeset(image_attrs, recipe)
        |> Repo.insert()
      end
    )
    |> Enum.all?(fn {status, _} -> status == :ok end)
    |>  case do
          true ->
            Enum.map(
              delete_attrs,
              fn {id, image_attrs} ->
                case image_attrs do
                  %{"delete" => "true"} ->
                    Repo.get!(SampsonCookbook.Image, id)
                    |> Repo.delete()
                  _ -> {:ok, %SampsonCookbook.Image{}}
                end
              end
            )
            |> Enum.all?(fn {status, _} -> status == :ok end)
            |>  case do
                  true -> {:ok, recipe}
                  _ -> {:error, recipe |> Recipe.update_changeset(%{})}
                end
          _ -> {:error, recipe |> Recipe.update_changeset(%{})}
        end
  end

  @doc """
  Deletes a Recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{source: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe) do
    Recipe.changeset(recipe, %{})
  end

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

      iex> get_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{source: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient) do
    Ingredient.changeset(ingredient, %{})
  end

  @doc """
  Returns the list of steps.

  ## Examples

      iex> list_steps()
      [%Step{}, ...]

  """
  def list_steps do
    Repo.all(Step)
  end

  @doc """
  Gets a single step.

  Raises `Ecto.NoResultsError` if the Step does not exist.

  ## Examples

      iex> get_step!(123)
      %Step{}

      iex> get_step!(456)
      ** (Ecto.NoResultsError)

  """
  def get_step!(id), do: Repo.get!(Step, id)

  @doc """
  Creates a step.

  ## Examples

      iex> create_step(%{field: value})
      {:ok, %Step{}}

      iex> create_step(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_step(attrs \\ %{}) do
    %Step{}
    |> Step.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a step.

  ## Examples

      iex> update_step(step, %{field: new_value})
      {:ok, %Step{}}

      iex> update_step(step, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_step(%Step{} = step, attrs) do
    step
    |> Step.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Step.

  ## Examples

      iex> delete_step(step)
      {:ok, %Step{}}

      iex> delete_step(step)
      {:error, %Ecto.Changeset{}}

  """
  def delete_step(%Step{} = step) do
    Repo.delete(step)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking step changes.

  ## Examples

      iex> change_step(step)
      %Ecto.Changeset{source: %Step{}}

  """
  def change_step(%Step{} = step) do
    Step.changeset(step, %{})
  end
end
