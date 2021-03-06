defmodule SampsonCookbookWeb.RecipeController do
  use SampsonCookbookWeb, :controller

  alias SampsonCookbook.Book
  alias SampsonCookbook.Book.Recipe

  def index(conn, %{"search" => search}) do
    recipes = Book.find_recipes(search)
    render(conn, "search.html", recipes: recipes, search: search)
  end

  def index(conn, _params) do
    recipes = Book.list_recipes()
    render(conn, "index.html", recipes: recipes, search: "")
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
        IO.inspect image_params
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

  def update(conn, %{"id" => id, "recipe" => recipe_params} = params) do
    recipe = Book.get_recipe!(id)
    recipe_params = Map.put_new(recipe_params, "tags", [])
    delete_image_params = params["delete_images"] || %{}
    image_params = params["images"] || %{}

    IO.inspect "MAIN FUNC"
    IO.inspect image_params
    IO.inspect delete_image_params

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

  def delete(conn, %{"id" => id}) do
    recipe = Book.get_recipe!(id)
    {:ok, _recipe} = Book.delete_recipe(recipe)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: Routes.recipe_path(conn, :index))
  end
end
