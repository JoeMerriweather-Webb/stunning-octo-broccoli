defmodule App.Schemas do
  alias OpenApiSpex.Schema

  defmodule Document do
    require OpenApiSpex
    alias App.SchemaExamples

    OpenApiSpex.schema(%{
      description: "An uploaded document and extracted data",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Document ID"},
        attributes: %Schema{
          type: :object,
          properties: %{
            filename: %Schema{type: :string, description: "Document filename"},
            content_type: %Schema{type: :string, description: "Document content_type"},
            plaintiffs: %Schema{
              type: :array,
              items: %Schema{type: :string},
              description: "Plaintiffs extracted from document"
            },
            defendants: %Schema{
              type: :array,
              items: %Schema{type: :string},
              description: "Defendants extracted from document"
            }
          }
        },
        links: %Schema{
          type: :object,
          properties: %{
            self: %Schema{type: :string, description: "link to get resource"}
          }
        },
        relationships: %Schema{
          type: :object
        },
        type: %Schema{type: :string, description: "resource type"}
      },
      required: [:content_type, :filename],
      example: SchemaExamples.document()
    })
  end

  defmodule DocumentResponse do
    require OpenApiSpex
    alias App.SchemaExamples

    OpenApiSpex.schema(%{
      title: "DocumentResponse",
      description: "Response schema for single docuement",
      type: :object,
      properties: %{
        data: Document,
        links: %Schema{
          type: :object,
          properties: %{
            self: %Schema{type: :string, description: "link to document list"}
          }
        },
        included: %Schema{type: :array}
      },
      example: %{
        "data" => SchemaExamples.document()
      }
    })
  end

  defmodule DocumentListResponse do
    require OpenApiSpex
    alias App.SchemaExamples

    OpenApiSpex.schema(%{
      title: "Document List Response",
      description: "Response schema for single docuement",
      type: :object,
      properties: %{
        data: %Schema{
          type: :array,
          items: Document,
          description: "List of documents"
        },
        links: %Schema{
          type: :object,
          properties: %{
            self: %Schema{type: :string, description: "link to document list"}
          }
        },
        included: %Schema{type: :array}
      },
      example: %{
        "data" => [SchemaExamples.document()]
      }
    })
  end

  defmodule DocumentCreateRequest do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "DocumentCreateRequest",
      description: "Request schema for a docuement",
      type: :object,
      properties: %{
        document: %Schema{type: :string, format: :binary, description: "File to upload"}
      }
    })
  end
end
