defmodule SampsonCookbook.Image.Preview do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Image

  schema "image_previews" do
    field :data, :binary
    belongs_to :image, Image
  end

  @doc false
  def changeset(preview, attrs) do
    preview
    |> cast(attrs, [:data, :image_id])
    |> validate_required([:data])
  end
end
