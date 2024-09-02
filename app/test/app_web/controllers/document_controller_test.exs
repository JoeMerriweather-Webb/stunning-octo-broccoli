defmodule AppWeb.DocumentControllerTest do
  use AppWeb.ConnCase

  @create_attrs %{
    document: %Plug.Upload{
      content_type: "application/xml",
      filename: "A.xml",
      path: Path.absname("test/support/fixtures/uploads/A.xml")
    }
  }

  @invalid_attrs %{
    document: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all documents", %{conn: conn} do
      document = Factory.insert(:document)
      conn = get(conn, ~p"/api/documents")

      assert [
               %{
                 "attributes" => %{
                   "content_type" => document.content_type,
                   "defendants" => document.defendants,
                   "filename" => document.filename,
                   "plaintiffs" => document.plaintiffs
                 },
                 "id" => document.id,
                 "links" => %{
                   "self" => "http://www.example.com/api/documents/#{document.id}"
                 },
                 "relationships" => %{},
                 "type" => "documents"
               }
             ] == json_response(conn, 200)["data"]
    end
  end

  describe "create document" do
    test "renders document when data is valid", %{conn: conn} do
      @create_attrs.document.path |> File.read!()
      conn = post(conn, ~p"/api/documents", @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/documents/#{id}")

      assert %{
               "id" => id,
               "attributes" => %{
                 "content_type" => @create_attrs.document.content_type,
                 "defendants" => [
                   "HILL-ROM COMPANY, INC., an Indiana corporation",
                   "DOES 1 through 100, inclusive"
                 ],
                 "filename" => @create_attrs.document.filename,
                 "plaintiffs" => ["ANGELO ANGELES"]
               },
               "links" => %{"self" => "http://www.example.com/api/documents/#{id}"},
               "relationships" => %{},
               "type" => "documents"
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/documents", document: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
