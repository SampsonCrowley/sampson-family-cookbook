defmodule SampsonCookbook.Repo.Migrations.CreateImagePreviews do
  use Ecto.Migration

  def change do
    create table(:image_previews) do
      add :image_id, references(:images, on_delete: :delete_all), null: false
      add :data, :binary
    end

    create index(:image_previews, [:image_id], unique: true)
  end
end
