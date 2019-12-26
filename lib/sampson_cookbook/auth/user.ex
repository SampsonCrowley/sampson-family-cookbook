defmodule SampsonCookbook.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SampsonCookbook.Auth.User

  schema "users" do
    field :email, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string, virtual: true
  end

  @doc false
  def create_changeset(user, attrs) do
    changeset(user, attrs, true)
  end

  @doc false
  def update_changeset(user, attrs) do
    changeset(user, attrs, nil)
  end

  def after_save({:ok, changeset}) do
    {:ok, %User{changeset | password: nil, password_confirmation: nil}}
  end

  def after_save(params), do: params

  defp changeset(user, attrs, force_confirmation) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> unique_constraint(:email)
    |> validate_password_confirmation(force_confirmation)
  end

  defp validate_password_confirmation(changeset, force) do
    case (force || get_change(changeset, :password)) do
      nil -> changeset
      _ ->
        changeset
        |> validate_required([:password])
        |> validate_length(:password, min: 8)
        |> validate_format(:password, ~r/(?=.*[0-9a-zA-Z])(?=.*[^a-zA-Z0-9])/, message: "must have at least one letter or number and one special character (not letter or number)")
        |> validate_confirmation(:password, message: "password and confirmation don't match")
    end
  end
end
