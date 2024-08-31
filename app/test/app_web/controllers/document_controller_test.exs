defmodule AppWeb.DocumentControllerTest do
  use AppWeb.ConnCase

  @create_attrs %{
    upload: %Plug.Upload{
      content_type: "application/xml",
      filename: "A.xml",
      path: Path.absname("test/support/fixtures/uploads/A.xml")
    }
  }

  @invalid_attrs %{
    upload: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all documents", %{conn: conn} do
      conn = get(conn, ~p"/api/documents")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create document" do
    test "renders document when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/documents", document: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/documents/#{id}")

      assert %{
               "id" => id,
               "content_type" => @create_attrs.upload.content_type,
               "defendants" => [],
               "filename" => @create_attrs.upload.filename,
               "plaintiffs" => []
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/documents", document: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
