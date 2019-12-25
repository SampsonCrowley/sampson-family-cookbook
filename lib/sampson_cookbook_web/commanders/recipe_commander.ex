defmodule SampsonCookbookWeb.RecipeCommander do
  use Drab.Commander
  # Place your event handlers here
  #
  # def button_clicked(socket, sender) do
  #   set_prop socket, "#output_div", innerHTML: "Clicked the button!"
  # end

  defhandler add_recipe_image(socket, _sender) do
    insert_html(
      socket,
      "#recipe_images",
      :beforeend,
      image_html()
    )
  end

  defhandler add_recipe_ingredient(socket, _sender) do
    insert_html(
      socket,
      "#ingredient_table_body",
      :beforeend,
      ingredient_html()
    )
  end

  defhandler add_recipe_step(socket, _sender) do
    insert_html(
      socket,
      "#step_table_body",
      :beforeend,
      step_html()
    )
  end

  def image_html() do
    item_no = Enum.random(999..5999)
    id = "recipe_images_#{item_no}_image"
    """
    <div class="form-group">
      <label for="#{id}" class="control-label">
      <input
        class="form-control"
        id="#{id}"
        name="images[#{item_no}][image]"
        type="file"
      >
    </div>
    """
  end

  def ingredient_html() do
    item_no = Enum.random(999..5999)

    """
      <tr>
        <td>
          <input
            class="form-control"
            id="recipe_ingredients_#{item_no}_name"
            name="recipe[ingredients][#{item_no}][name]"
            type="text"
          >
        </td>
        <td>
          <input
            class="form-control"
            id="recipe_ingredients_#{item_no}_amount"
            name="recipe[ingredients][#{item_no}][amount]"
            type="text"
          >
        </td>
        <td>
          <input
            name="recipe[ingredients][#{item_no}][required]"
            type="hidden" value="false">
          <input
            class="checkbox"
            id="recipe_ingredients_#{item_no}_required"
            name="recipe[ingredients][#{item_no}][required]"
            type="checkbox"
            value="true"
            checked="checked"
          >
        </td>
        <td>
          <button type="button" class="remove-has-many-row">Cancel</button>
        </td>
      </tr>
    """
  end

  def step_html() do
    item_no = Enum.random(999..5999)

    """
      <tr>
        <td colspan="3" style="width: 75%">
          <textarea
            class="form-control"
            id="recipe_steps_#{item_no}_details"
            name="recipe[steps][#{item_no}][details]"
            type="text"
          ></textarea>
        </td>
        <td>
          <input
            class="form-control"
            id="recipe_steps_#{item_no}_order"
            name="recipe[steps][#{item_no}][order]"
            type="number"
          >
        </td>
        <td>
          <button type="button" class="remove-has-many-row">Cancel</button>
        </td>
      </tr>
    """
  end

  # Place you callbacks here
  #
  # onload :page_loaded
  #
  # def page_loaded(socket) do
  #   set_prop socket, "div.jumbotron h2", innerText: "This page has been drabbed"
  # end
end
