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

    test "get_document!/1 returns the document with given id" do
      document = Factory.insert(:document)
      assert Documents.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      valid_attrs = %{
        filename: "some filename",
        content_type: "some content_type",
        upload: "some upload",
        plaintiffs: ["option1", "option2"],
        defendants: ["option1", "option2"]
      }

      assert {:ok, %Document{} = document} = Documents.create_document(valid_attrs)
      assert document.filename == "some filename"
      assert document.content_type == "some content_type"
      assert document.upload == "some upload"
      assert document.plaintiffs == ["option1", "option2"]
      assert document.defendants == ["option1", "option2"]
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_document(@invalid_attrs)
    end
  end
end
