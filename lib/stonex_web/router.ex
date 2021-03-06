defmodule StonexWeb.Router do
  use StonexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug StonexWeb.Auth.Pipeline
  end

  pipeline :bodyguard do
    plug StonexWeb.BodyGuard
  end

  scope "/api", StonexWeb do
    pipe_through :api

    get "/", WelcomeController, :hello

    scope "/account" do
      post "/signup", AccountController, :create
      post "/login", AuthController, :login
    end

    scope "/backoffice" do
      post "/login", AuthController, :backoffice_login
    end
  end

  scope "/api", StonexWeb do
    pipe_through [:api, :auth, :bodyguard]

    scope "/transaction" do
      post "/transfer", TransactionController, :transfer
      post "/withdraw", TransactionController, :withdraw
    end

    scope "/backoffice" do
      post "/user", BackofficeController, :create
      get "/reports", BackofficeController, :reports
    end
  end

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
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: StonexWeb.Telemetry
    end
  end
end
