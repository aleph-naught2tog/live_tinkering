defmodule LiveTinkeringWeb.Router do
  use LiveTinkeringWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveTinkeringWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/whiteboard", WhiteboardController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveTinkeringWeb do
  #   pipe_through :api
  # end
end
