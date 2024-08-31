defmodule AppWeb.DocumentJSON do
  alias App.Documents.Document

  @doc """
  Renders a list of documents.
  """
  def index(%{documents: documents}) do
    %{data: for(document <- documents, do: data(document))}
  end

  @doc """
  Renders a single document.
  """
  def show(%{document: document}) do
    %{data: data(document)}
  end

  defp data(%Document{} = document) do
    %{
      id: document.id,
      filename: document.filename,
      content_type: document.content_type,
      plaintiffs: document.plaintiffs,
      defendants: document.defendants
    }
  end
end
