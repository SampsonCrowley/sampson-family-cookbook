defmodule SampsonCookbook.Auth.ErrorHandler do
  use SampsonCookbookWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_flash(:error, "You must be signed in to access this page")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
