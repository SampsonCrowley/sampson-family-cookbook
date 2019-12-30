defmodule SampsonCookbook.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Repo
  alias SampsonCookbook.Book
  alias SampsonCookbook.Image
  alias SampsonCookbook.Image.Preview

  schema "images" do
    belongs_to :recipe, Book.Recipe
    field :image, :any, virtual: true
    field :image_data, :binary
    field :image_name, :string
    field :image_type, :string
    has_one :preview, Preview
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
        auto_orient_image(image.path)

        changeset
        |> put_change(:image_type, image.content_type)
        |> put_change(:image_name, image.filename)
        |> put_change(:image_data, base64_from_path(image.path))
        |> store_preview()
      _ -> changeset
    end
  end

  defp store_preview(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{image: image}} ->
        resize_image(image.path)

        changeset
        |>  put_assoc(
              :preview,
              %Preview{
                data: base64_from_path(image.path)
              }
            )
      _ -> changeset
    end
  end

  defp auto_orient_image(path) do
    Mogrify.open(path)
    |> Mogrify.auto_orient()
    |> Mogrify.save(in_place: true)
  end

  defp resize_image(path) do
    Mogrify.open(path)
    |> Mogrify.resize_to_limit("150x150")
    |> Mogrify.save(in_place: true)
  end

  defp base64_from_path(path) do
    :base64.encode(File.read!(path))
  end

  @doc """
  Returns the list of image_previews.

  ## Examples

      iex> list_image_previews()
      [%Preview{}, ...]

  """
  def list_image_previews do
    Repo.all(Preview)
  end

  @doc """
  Gets a single preview.

  Raises `Ecto.NoResultsError` if the Preview does not exist.

  ## Examples

      iex> get_preview!(123)
      %Preview{}

      iex> get_preview!(456)
      ** (Ecto.NoResultsError)

  """
  def get_preview!(id) do
    image =
      Repo.get!(Image, id)
      |> Repo.preload(:preview)
    if image.preview do
      image
    else
      path = File.cwd!() <> "/tmp/" <> Ecto.UUID.generate() <> "." <> extension_from_content_type(image.image_type)
      File.write!(path, :base64.decode(image.image_data))
      resize_image(path)
      create_preview(%{image_id: id, data: base64_from_path(path)})
      File.rm(path)
      get_preview!(id)
    end
  end

  defp extension_from_content_type(content_type) do
    String.replace_prefix(content_type, "image/", "")
  end

  @doc """
  Creates a preview.

  ## Examples

      iex> create_preview(%{field: value})
      {:ok, %Preview{}}

      iex> create_preview(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_preview(attrs \\ %{}) do
    %Preview{}
    |> Preview.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a preview.

  ## Examples

      iex> update_preview(preview, %{field: new_value})
      {:ok, %Preview{}}

      iex> update_preview(preview, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_preview(%Preview{} = preview, attrs) do
    preview
    |> Preview.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Preview.

  ## Examples

      iex> delete_preview(preview)
      {:ok, %Preview{}}

      iex> delete_preview(preview)
      {:error, %Ecto.Changeset{}}

  """
  def delete_preview(%Preview{} = preview) do
    Repo.delete(preview)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking preview changes.

  ## Examples

      iex> change_preview(preview)
      %Ecto.Changeset{source: %Preview{}}

  """
  def change_preview(%Preview{} = preview) do
    Preview.changeset(preview, %{})
  end
end
