defmodule SampsonCookbookWeb.Router do
  use SampsonCookbookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug SampsonCookbook.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: SampsonCookbookWeb.SessionController
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SampsonCookbookWeb do
    pipe_through [:browser, :auth]

    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", SampsonCookbookWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/users", UserController
    resources "/recipes", RecipeController
    get "/images/:id", ImageController, :index
    get "/", RecipeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SampsonCookbookWeb do
  #   pipe_through :api
  # end
end
