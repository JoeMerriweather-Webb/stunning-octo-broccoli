defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: App.ApiSpec
  end

  scope "/api" do
    pipe_through :api

    scope "/", AppWeb do
      resources "/documents", DocumentController, only: [:index, :show, :create]
    end

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end
end
