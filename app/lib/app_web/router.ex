defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", AppWeb do
    pipe_through :api

    resources "/documents", DocumentController, only: [:index, :show, :create]
  end
end
