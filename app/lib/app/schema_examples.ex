defmodule App.SchemaExamples do
  def document do
    %{
      "attributes" => %{
        "content_type" => "application/xml",
        "defendants" => ["A", "B"],
        "filename" => "A.xml",
        "plaintiffs" => ["C", "D"]
      },
      "id" => "b687d172-61fd-4374-9e54-8731906c3a04",
      "links" => %{
        "self" => "http://www.example.com/api/documents/b687d172-61fd-4374-9e54-8731906c3a04"
      },
      "relationships" => %{},
      "type" => "documents"
    }
  end
end
