defmodule SampsonCookbook.BookTest do
  use SampsonCookbook.DataCase

  alias SampsonCookbook.Book

  describe "recipes" do
    alias SampsonCookbook.Book.Recipe

    @valid_attrs %{est_time: 42, name: "some name", tags: ["asdf"]}
    @update_attrs %{est_time: 43, name: "some updated name", tags: ["fdsa"]}
    @invalid_attrs %{est_time: nil, name: nil, tags: nil}

    def recipe_fixture(attrs \\ %{}) do
      {:ok, recipe} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Book.create_recipe()

      recipe
    end

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Book.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Book.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      assert {:ok, %Recipe{} = recipe} = Book.create_recipe(@valid_attrs)
      assert recipe.est_time == 42
      assert recipe.name == "some name"
      assert recipe.tags == ["asdf"]
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Book.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{} = recipe} = Book.update_recipe(recipe, @update_attrs)
      assert recipe.est_time == 43
      assert recipe.name == "some updated name"
      assert recipe.tags == ["fdsa"]
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Book.update_recipe(recipe, @invalid_attrs)
      assert recipe == Book.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Book.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Book.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Book.change_recipe(recipe)
    end
  end

  describe "ingredients" do
    alias SampsonCookbook.Book.Ingredient

    @valid_attrs %{amount: "some amount", name: "some name", required: true}
    @update_attrs %{amount: "some updated amount", name: "some updated name", required: false}
    @invalid_attrs %{amount: nil, name: nil, required: nil}

    def ingredient_fixture(attrs \\ %{}) do
      {:ok, ingredient} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Book.create_ingredient()

      ingredient
    end

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Book.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Book.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      assert {:ok, %Ingredient{} = ingredient} = Book.create_ingredient(@valid_attrs)
      assert ingredient.amount == "some amount"
      assert ingredient.name == "some name"
      assert ingredient.required == true
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Book.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{} = ingredient} = Book.update_ingredient(ingredient, @update_attrs)
      assert ingredient.amount == "some updated amount"
      assert ingredient.name == "some updated name"
      assert ingredient.required == false
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Book.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Book.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Book.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Book.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Book.change_ingredient(ingredient)
    end
  end

  describe "steps" do
    alias SampsonCookbook.Book.Step

    @valid_attrs %{details: "some details", order: 42}
    @update_attrs %{details: "some updated details", order: 43}
    @invalid_attrs %{details: nil, order: nil}

    def step_fixture(attrs \\ %{}) do
      {:ok, step} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Book.create_step()

      step
    end

    test "list_steps/0 returns all steps" do
      step = step_fixture()
      assert Book.list_steps() == [step]
    end

    test "get_step!/1 returns the step with given id" do
      step = step_fixture()
      assert Book.get_step!(step.id) == step
    end

    test "create_step/1 with valid data creates a step" do
      assert {:ok, %Step{} = step} = Book.create_step(@valid_attrs)
      assert step.details == "some details"
      assert step.order == 42
    end

    test "create_step/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Book.create_step(@invalid_attrs)
    end

    test "update_step/2 with valid data updates the step" do
      step = step_fixture()
      assert {:ok, %Step{} = step} = Book.update_step(step, @update_attrs)
      assert step.details == "some updated details"
      assert step.order == 43
    end

    test "update_step/2 with invalid data returns error changeset" do
      step = step_fixture()
      assert {:error, %Ecto.Changeset{}} = Book.update_step(step, @invalid_attrs)
      assert step == Book.get_step!(step.id)
    end

    test "delete_step/1 deletes the step" do
      step = step_fixture()
      assert {:ok, %Step{}} = Book.delete_step(step)
      assert_raise Ecto.NoResultsError, fn -> Book.get_step!(step.id) end
    end

    test "change_step/1 returns a step changeset" do
      step = step_fixture()
      assert %Ecto.Changeset{} = Book.change_step(step)
    end
  end
end
