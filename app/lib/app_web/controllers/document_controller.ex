defmodule AppWeb.DocumentController do
  use AppWeb, :controller

  alias App.Documents
  alias App.Documents.Document

  action_fallback AppWeb.FallbackController

  def index(conn, _params) do
    documents = Documents.list_documents()
    render(conn, :index, data: documents)
  end

  def create(conn, %{"document" => document_params}) do
    document_params = get_create_params(document_params)

    with {:ok, %Document{} = document} <- Documents.create_document(document_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/documents/#{document}")
      |> render(:show, data: document)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Documents.get_document!(id)
    render(conn, :show, data: document)
  end

  def get_create_params(document_params) do
    case document_params["upload"] do
      %Plug.Upload{content_type: content_type, filename: filename, path: path} ->
        %{content_type: content_type, filename: filename, upload: File.read!(path)}

      _ ->
        %{content_type: nil, filename: nil, upload: nil}
    end
  end
end
