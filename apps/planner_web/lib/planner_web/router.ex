defmodule PlannerWeb.Router do
  use PlannerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PlannerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PlannerWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PlannerWeb.Plugs.ApiAuthorizationPlug
  end

  pipeline :auth do
    plug PlannerWeb.Pipeline
    plug PlannerWeb.CurrentUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :ensure_no_auth do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :allowed_for_users do
    plug PlannerWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug PlannerWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  scope "/", PlannerWeb do
    pipe_through [:browser, :auth]
    get "/", PageController, :index
    get "/another_index", PageController, :another_index
    get "/another_other_index", PageController, :another_other_index
  end

  scope "/", PlannerWeb do
    pipe_through [:browser, :auth, :ensure_no_auth]
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/register", UserController, :register_page
    post "/register", UserController, :register
  end

  scope "/", PlannerWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]
    # Logout
    get "/logout", SessionController, :logout
    # Setting page
    get "/settings", PageController, :settings
    # Invite system of event
    post "/events/:id/invite/", EventController, :invite
    post "/events/:id/accept/", EventController, :accept_invite
    post "/events/:id/decline/", EventController, :decline_invite
    post "/events/:id/reset/", EventController, :reset_invite
    # Follow/Unfollow a user
    post "/users/:id/follow/", UserController, :follow
    post "/users/:id/unfollow/", UserController, :unfollow
    # Show all users
    get "/users", UserController, :user_index
    # Change password
    post "/change_pass", UserController, :change_pass
    put "/change_pass", UserController, :change_pass
    # Change image
    post "/change_image", UserController, :change_image
    put "/change_image", UserController, :change_image
    # Generate Api-keys
    post "/generate", ApiController, :generate
    # Still need to fix this
    resources "/events", EventController
    # Show user profile
    resources "/users", UserController, only: [:show]
  end

  scope "/admin", PlannerWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]
    resources "/users", UserController
    get "/", PageController, :admin_index
  end

  scope "/api", PlannerWeb do
    pipe_through [:api]
    get "/users/:id", ApiController, :show
  end

  scope "/api", PlannerWeb do
    pipe_through [:api, :authenticate_api_user]
    get "/users", ApiController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PlannerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PlannerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
