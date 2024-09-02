# App

## Local Development

### Setup

Setup that applies to the following sections. All mix commands should be run
from the `app/` directory.

* Start Postgres locally. It should be reachable at localhost:5432 with username
  `postgres` and password `postgres`.
* Run `mix setup` to install and setup dependencies

### Start the Server

Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

### Run the Tests

Run `mix test`

### Run the HTTP Tests

A hurl script is provided to exercise all of the APIs through HTTP requests. Run
`make http_tests` from the parent directory.

In addition, the APIs can be requested through curl with the following:

#### Create A Document

* Run `curl --form 'document=@A.xml;type=application/xml' 'http://localhost:4000/api/documents'`

#### Get A Document

* Replace `<document_id>` in the command below with an existing one.
* Run `curl 'http://localhost:4000/api/documents/<document_id>`

#### List Documents
* Run `curl 'http://localhost:4000/api/documents'`

### API Documentation

The API is documented with OpenAPI. With the server running locally, the spec is
available at `http://localhost:4000/api/openapi`. In addition, a SwaggerUI for
documentation and testing requests is available at
`http://localhost:4000/api/swaggerui`.
