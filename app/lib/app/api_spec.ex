defmodule App.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths}
  alias AppWeb.Router
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [%OpenApiSpex.Server{url: "http://localhost:4000"}],
      info: %Info{
        title: "App",
        version: "1.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
