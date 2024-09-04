defmodule App.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Documents.Document

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document(123)
      {:ok, %Document{}}

      iex> get_document(456)
      {:error, :not_found}

  """
  def get_document(id) do
    if document = Repo.get(Document, id) do
      {:ok, document}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_document(attrs \\ %{}) do
    changeset = Document.changeset(%Document{}, attrs)

    with {:ok, changeset} <- Document.wrap_changeset(changeset) do
      extracted_data = App.Documents.Extractor.extract_data(changeset.changes.upload)

      changeset
      |> Ecto.Changeset.change(extracted_data)
      |> Repo.insert()
    end
  end
end
