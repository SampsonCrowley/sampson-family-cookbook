defmodule SampsonCookbookWeb.RecipeView do
  use SampsonCookbookWeb, :view

  def cook_time(recipe) do
    value = recipe.est_time || 0
    seconds = rem(value,60)
    minutes = div(rem(value - seconds, (60 * 60)), 60)
    hours = div((value - (minutes + seconds)), (60 * 60))
    "#{hours} hours, #{minutes} minutes, #{seconds} seconds"
  end

  def tag_list(recipe) do
    case recipe.tags do
      nil -> ''
      _ -> Enum.join(recipe.tags, ", ")
    end
  end

  def yes_no(value) do
    case !!value do
      true -> 'Yes'
      false -> 'No'
    end
  end

  def ordered_steps(steps) do
    (steps || [])
    |> Enum.with_index()
    # case steps do
    #   nil -> []
    #   _ -> Enum.sort(steps, fn(x,y) -> x.order < y.order end) |> Enum.with_index
    # end
  end

  def image_ids(recipe), do: SampsonCookbook.Book.get_recipe_image_ids(recipe)
end
