defmodule SampsonCookbookWeb.AuthHelpers do
  @moduledoc """
  Conveniences for authentication based view changes.
  """
  alias SampsonCookbook.Auth.Guardian

  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn)
end
