defmodule App.DocumentsTest do
  use App.DataCase

  alias App.Documents

  describe "documents" do
    alias App.Documents.Document

    @invalid_attrs %{
      filename: nil,
      content_type: nil,
      upload: nil,
      plaintiffs: nil,
      defendants: nil
    }

    test "list_documents/0 returns all documents" do
      document = Factory.insert(:document)
      assert Documents.list_documents() == [document]
    end

    test "get_document/1 returns the document with given id" do
      document = Factory.insert(:document)
      assert Documents.get_document(document.id) == {:ok, document}
    end

    test "get_document/1 returns not found error when record doesn't exist" do
      assert Documents.get_document(Ecto.UUID.generate()) == {:error, :not_found}
    end

    test "create_document/1 with valid data creates a document" do
      upload = Path.absname("test/support/fixtures/uploads/A.xml") |> File.read!()

      valid_attrs = %{
        filename: "some filename",
        content_type: "some content_type",
        upload: upload
      }

      assert {:ok, %Document{} = document} = Documents.create_document(valid_attrs)
      assert document.filename == "some filename"
      assert document.content_type == "some content_type"
      assert document.upload == upload
      assert document.plaintiffs == ["ANGELO ANGELES"]

      assert document.defendants == [
               "HILL-ROM COMPANY, INC., an Indiana corporation",
               "DOES 1 through 100, inclusive"
             ]
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end
  end
end
