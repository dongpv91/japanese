defmodule JapaneseWeb.Router do
  use JapaneseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug JapaneseWeb.Content
  end

  scope "/", JapaneseWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/" do
    pipe_through :api

    if Mix.env == :dev do
      # 開発環境のため、ウェブビューでGraphQL API toolkitを表示します
      forward "/graphql", Absinthe.Plug.GraphiQL, schema: JapaneseWeb.Schema
    else
      forward "/graphql", Absinthe.Plug, schema: JapaneseWeb.Schema
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", JapaneseWeb do
  #   pipe_through :api
  # end
end
