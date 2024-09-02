# Create a document
POST http://host.docker.internal:4000/api/documents
[MultipartFormData]
document: file,A.xml;
HTTP 201
[Captures]
document_id: jsonpath "$.data.id"

# Get a document
GET http://host.docker.internal:4000/api/documents/{{document_id}}
HTTP 200

# List documents
GET http://host.docker.internal:4000/api/documents
HTTP 200