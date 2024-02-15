defmodule BookstoreWeb.Router do
  use BookstoreWeb, :router
  import Phoenix.LiveView.Router

  import BookstoreWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BookstoreWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug BookstoreWeb.Context
  end

  scope "/" do
    pipe_through :graphql
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: BookstoreWeb.Schema
  end

  scope "/" do
    pipe_through [:graphql, :require_authenticated_api_user]

    forward "/graphql", Absinthe.Plug,
      schema: BookstoreWeb.Schema,
      interface: :simple,
      context: %{pubsub: BookstoreWeb.Endpoint}
  end

  scope "/", BookstoreWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/books/new", BookController, :new
    post "/books/new", BookController, :create
    get "/books/:id/edit", BookController, :edit
    put "/books/:id", BookController, :update
    delete "/books/:id", BookController, :delete
  end

  scope "/", BookstoreWeb do
    pipe_through :browser

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BookstoreWeb.Schema,
      interface: :simple,
      context: %{pubsub: BookstoreWeb.Endpoint}

    live "/", BooksLive
    live "/books", BooksLive
    get "/books/:id", BookController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookstoreWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:bookstore, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BookstoreWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BookstoreWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", BookstoreWeb do
    pipe_through [:browser, :require_authenticated_user]
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", BookstoreWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end
end
