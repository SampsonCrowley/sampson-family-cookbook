defmodule SampsonCookbook.Repo.Migrations.AddImageUpload do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :recipe_id, references(:recipes, on_delete: :delete_all)
      add :image_data, :binary
      add :image_name, :text
      add :image_type, :text
    end
  end
end
