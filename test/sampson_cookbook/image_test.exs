defmodule SampsonCookbook.ImageTest do
  use SampsonCookbook.DataCase

  alias SampsonCookbook.Image

  describe "image_previews" do
    alias SampsonCookbook.Image.Preview

    @valid_attrs %{data: "some data"}
    @update_attrs %{data: "some updated data"}
    @invalid_attrs %{data: nil}

    def preview_fixture(attrs \\ %{}) do
      {:ok, preview} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Image.create_preview()

      preview
    end

    test "list_image_previews/0 returns all image_previews" do
      preview = preview_fixture()
      assert Image.list_image_previews() == [preview]
    end

    test "get_preview!/1 returns the preview with given id" do
      preview = preview_fixture()
      assert Image.get_preview!(preview.id) == preview
    end

    test "create_preview/1 with valid data creates a preview" do
      assert {:ok, %Preview{} = preview} = Image.create_preview(@valid_attrs)
      assert preview.data == "some data"
    end

    test "create_preview/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Image.create_preview(@invalid_attrs)
    end

    test "update_preview/2 with valid data updates the preview" do
      preview = preview_fixture()
      assert {:ok, %Preview{} = preview} = Image.update_preview(preview, @update_attrs)
      assert preview.data == "some updated data"
    end

    test "update_preview/2 with invalid data returns error changeset" do
      preview = preview_fixture()
      assert {:error, %Ecto.Changeset{}} = Image.update_preview(preview, @invalid_attrs)
      assert preview == Image.get_preview!(preview.id)
    end

    test "delete_preview/1 deletes the preview" do
      preview = preview_fixture()
      assert {:ok, %Preview{}} = Image.delete_preview(preview)
      assert_raise Ecto.NoResultsError, fn -> Image.get_preview!(preview.id) end
    end

    test "change_preview/1 returns a preview changeset" do
      preview = preview_fixture()
      assert %Ecto.Changeset{} = Image.change_preview(preview)
    end
  end
end
