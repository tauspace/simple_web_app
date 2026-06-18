defmodule SimpleWebAppWeb.Router do
  use SimpleWebAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpleWebAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleWebAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/download-pdf", PageController, :download_pdf
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleWebAppWeb do
  #   pipe_through :api
  # end
end
