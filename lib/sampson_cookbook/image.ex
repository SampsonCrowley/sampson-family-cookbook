defmodule SampsonCookbook.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Book
  alias SampsonCookbook.Image

  schema "images" do
    belongs_to :recipe, Book.Recipe
    field :image, :any, virtual: true
    field :image_data, :binary
    field :image_name, :string
    field :image_type, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image])
    |> store_image()
  end

  @doc false
  def update_changeset(%Image{recipe_id: nil}, attrs, recipe) do
    Ecto.build_assoc(recipe, :images)
    |> cast(attrs, [:image, :recipe_id])
    |> validate_required([:image, :recipe_id])
    |> store_image()
  end

  defp store_image(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{image: image}} ->
        changeset
        |> put_change(:image_type, image.content_type)
        |> put_change(:image_name, image.filename)
        |> put_change(:image_data, :base64.encode(File.read!(image.path)))
      _ -> changeset
    end
  end
end
