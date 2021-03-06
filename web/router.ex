defmodule BlurtEx.Router do
  use BlurtEx.Web, :router

  if Mix.env == :dev, do: forward "/sent_emails", Bamboo.EmailPreviewPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: BlurtEx.TokenController
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlurtEx do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:create]
    get "/", SessionController, :new
    get "/password_recovery", PasswordController, :forgot
    post "/password_recovery", PasswordController, :recover
  end

  scope "/", BlurtEx do
    pipe_through [:browser, :browser_auth]
    resources "/users", UserController, only: [:show, :index, :edit, :update, :delete]
    resources "/sessions", SessionController, only: [:delete]
    get "/chat", ChatController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlurtEx do
  #   pipe_through :api
  # end
end
