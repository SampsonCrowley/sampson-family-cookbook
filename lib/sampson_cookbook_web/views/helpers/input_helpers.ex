defmodule SampsonCookbookWeb.InputHelpers do
  use Phoenix.HTML
  alias SampsonCookbookWeb.ErrorHelpers

  def array_input(form, field), do: array_input(form, field, true)

  def array_input(form, field, numbered) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    id = Phoenix.HTML.Form.input_id(form,field)
    wrapper_type = case numbered do
      false -> :ul
      _ -> :ol
    end
    content_tag wrapper_type, id: container_id(id), class: "array-input-container", data: [index: Enum.count(values) ] do
      values
      |> Enum.with_index()
      |> Enum.map(fn {value, index} ->
        array_form_elements(form,field, value, index)
      end)
    end
  end

  def array_add_button(form, field), do: array_add_button(form, field, "Add")

  def array_add_button(form, field, label) do
    id = Phoenix.HTML.Form.input_id(form,field)
    content = array_form_elements(form,field,"","__name__")
      |> safe_to_string
    data = [
      prototype: content,
      container: container_id(id)
    ];
    content_tag :button, type: "button", data: data, class: "add-form-field" do
      label
    end
  end

  def duration_input(form, field) do
    unparsed = Phoenix.HTML.Form.input_value(form, field)
    value = cond do
      is_integer(unparsed) -> unparsed
      is_binary(unparsed) -> String.to_integer(unparsed)
      is_float(unparsed) -> Kernel.trunc(unparsed)
      true -> 0
    end
    seconds = rem(value,60)
    minutes = div(rem(value - seconds, (60 * 60)), 60)
    hours = div((value - (minutes + seconds)), (60 * 60))
    id = Phoenix.HTML.Form.input_id(form,field)
    content_tag :div, id: container_id(id), class: "duration-input-container row", data: [value: value ] do
      [
        content_tag :div, class: "column" do
          [
            hidden_input(form, field),
            content_tag :label do
              [
                "Hours",
                duration_form_element(form, field, hours, "hours")
              ]
            end
          ]
        end,

        content_tag :div, class: "column" do
          content_tag :label do
            [
              "Minutes",
              duration_form_element(form, field, minutes, "minutes")
            ]
          end
        end,

        content_tag :div, class: "column" do
          content_tag :label do
            [
              "Seconds",
              duration_form_element(form, field, seconds, "seconds")
            ]
          end
        end
      ]
    end
  end

  def confirmed_password_input(form, field) do
    confirmation_field = String.to_atom("#{field}_confirmation")
    id = Phoenix.HTML.Form.input_id(form,field)
    confirmation_id = Phoenix.HTML.Form.input_id(form,field)

    content_tag :div, id: container_id(id), class: "password-input-container row", data: [id: id] do
      [
        content_tag :div, class: "column column-100 form-group" do
          [
            label(form, field),
            password_input(form, field, data: [confirmation: confirmation_id]),
            ErrorHelpers.error_tag(form, field)
          ]
        end,

        content_tag :div, class: "column column-100 form-group" do
          [
            label(form, confirmation_field),
            password_input(form, confirmation_field, data: [id: id]),
            ErrorHelpers.error_tag(form, confirmation_field)
          ]
        end
      ]
    end
  end

  defp array_form_elements(form, field, value, index) do
    type = Phoenix.HTML.Form.input_type(form, field)
    id = Phoenix.HTML.Form.input_id(form,field)
    new_id = id <> "_#{index}"
    input_opts = [
      name: array_field_name(form,field),
      value: value,
      id: new_id,
      class: "form-control"
    ]
    content_tag :li do
      [
        apply(Phoenix.HTML.Form, type, [form, field, input_opts]),
        content_tag :button, type: "button", data: [id: new_id], class: "remove-form-field" do
          "Remove"
        end
       ]
     end
  end

  defp duration_form_element(form, field, value, name) do
    type = Phoenix.HTML.Form.input_type(form, field)
    id = Phoenix.HTML.Form.input_id(form,field)
    new_id = id <> "_#{name}"
    input_opts = [
      name: Phoenix.HTML.Form.input_id(form,field) <> "_#{name}",
      value: value,
      data: [id: id],
      id: new_id,
      class: "form-control duration-input duration-input-#{name}",
      step: 1,
      min: 0
    ]
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end

  defp container_id(id), do: id <> "_container"

  defp array_field_name(form, field) do
    Phoenix.HTML.Form.input_name(form, field) <> "[]"
  end
end
