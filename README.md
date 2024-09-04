# App

## Local Development

### Setup

Setup that applies to the following sections. All mix commands should be run
from the `app/` directory, while make commands should be run from the top-level.

* Start Postgres locally. It should be reachable at localhost:5432 with username
  `postgres` and password `postgres`. `make up` is provided to start Postgres in
  a Docker container.
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

## Deploying a Release (Fly.io)

This project is set up to deploy a self-contained release. This section details
how to deploy the app to Fly.io and the steps will vary to deploy to a different
platform.

* [Install the Fly.io CLI](https://fly.io/docs/flyctl/install/)
* Run `fly auth signup` if you don't already have an account
* Make sure your account is set up with a payment method.
* Run `flyctl auth login` to log in
* Run `flyctl launch`. This will allow you to make configuration changes and
  deploy the app. There shouldn't be anything to change. This command will do a
  number of things:
  * create a Postgres instance
  * create a database
  * set DATABASE_URL from the created Postgres instance as a secret
  * generate the SECRET_KEY_BASE and set it as a secret
  * build a release
  * run the migrations
  * deploy the app