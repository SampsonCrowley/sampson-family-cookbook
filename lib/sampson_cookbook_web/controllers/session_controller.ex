defmodule SampsonCookbookWeb.SessionController do
  use SampsonCookbookWeb, :controller

  alias SampsonCookbook.Auth

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    Auth.login_by_email_and_pass(email, pass)
    |> login_reply(conn)
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out(Auth.Guardian)
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(Auth.Guardian, user)
    |> redirect(to: Routes.recipe_path(conn, :index))
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
