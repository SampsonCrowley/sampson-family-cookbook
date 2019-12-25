defmodule SampsonCookbookWeb.RecipeController do
  use SampsonCookbookWeb, :controller
  use Drab.Controller

  alias SampsonCookbook.Book
  alias SampsonCookbook.Book.Recipe

  def index(conn, _params) do
    recipes = Book.list_recipes()
    render(conn, "index.html", recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Book.change_recipe(
      %Recipe{
        ingredients: [],
        steps: []
      }
    )
    render(conn, "new.html", changeset: changeset, id: nil)
  end

  def create(conn, %{"recipe" => recipe_params, "images" => image_params}) do
    case Book.create_recipe(recipe_params) do
      {:ok, recipe} ->
        case Book.insert_images(recipe, image_params, %{}) do
          {:ok, _recipe} ->
            conn
            |> put_flash(:info, "Recipe created successfully.")
            |> redirect(to: Routes.recipe_path(conn, :show, recipe))

          {:error, _changeset} ->
            conn
            |> put_flash(:info, "Recipe created successfully. Image(s) Not Uploaded")
            |> redirect(to: Routes.recipe_path(conn, :show, recipe))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, id: nil)
    end
  end
  def create(conn, %{"recipe" => recipe_params}), do: create(conn, %{"recipe" => recipe_params, "images" => %{}})


  def show(conn, %{"id" => id}) do
    recipe = Book.get_recipe!(id)
    render(conn, "show.html", recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Book.get_recipe!(id)
    changeset = Book.change_recipe(recipe)
    render(conn, "edit.html", recipe: recipe, changeset: changeset, id: id)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params, "delete_images" => delete_image_params, "images" => image_params}) do
    recipe = Book.get_recipe!(id)
    recipe_params = Map.put_new(recipe_params, "tags", [])

    case Book.update_recipe(recipe, recipe_params) do
      {:ok, recipe} ->
        case Book.insert_images(recipe, image_params, delete_image_params) do
          {:ok, _recipe} ->
            conn
            |> put_flash(:info, "Recipe updated successfully.")
            |> redirect(to: Routes.recipe_path(conn, :show, recipe))

          {:error, _changeset} ->
            conn
            |> put_flash(:info, "Recipe updated successfully. Image(s) Not Uploaded/Deleted")
            |> redirect(to: Routes.recipe_path(conn, :show, recipe))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", recipe: recipe, changeset: changeset, id: id)
    end
  end
  def update(conn, %{"id" => id, "recipe" => recipe_params, "delete_images" => delete_image_params}), do: update(conn, %{"id" => id, "recipe" => recipe_params, "delete_images" => delete_image_params, "images" => %{}})
  def update(conn, %{"id" => id, "recipe" => recipe_params}), do: update(conn, %{"id" => id, "recipe" => recipe_params, "delete_images" => %{}, "images" => %{}})

  def delete(conn, %{"id" => id}) do
    recipe = Book.get_recipe!(id)
    {:ok, _recipe} = Book.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end
end
