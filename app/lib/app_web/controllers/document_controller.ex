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

  def get_create_params(%Plug.Upload{} = upload) do
    %{
      content_type: upload.content_type,
      filename: upload.filename,
      upload: File.read!(upload.path)
    }
  end

  def get_create_params(_upload) do
    %{content_type: nil, filename: nil, upload: nil}
  end
end
