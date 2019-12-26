defmodule SampsonCookbook.AuthTest do
  use SampsonCookbook.DataCase

  alias SampsonCookbook.Auth

  describe "users" do
    alias SampsonCookbook.Auth.User

    @valid_attrs %{email: "some email", password: "password.", password_confirmation: "password."}
    @update_attrs %{email: "some updated email", password: "some updated password", password_confirmation: "some updated password"}
    @invalid_create_attrs %{email: "email"}
    @invalid_email_attrs %{email: nil}
    @invalid_password_attrs %{email: "new_email", password: "password", password_confirmation: "password"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_create_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_email_attrs)
      assert user == Auth.get_user!(user.id)

      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_password_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "changeset is invalid if password and confirmation do not match" do
      changeset = User.update_changeset(%User{}, %{email: "test@test.com", password: "foo", password_confirmation: "bar"})
      refute changeset.valid?
    end
  end
end
