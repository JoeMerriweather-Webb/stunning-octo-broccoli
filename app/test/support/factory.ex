defmodule App.Factory do
  use ExMachina.Ecto, repo: App.Repo
  alias App.Documents.Document

  def document_factory do
    %Document{
      content_type: Faker.File.mime_type(),
      filename: Faker.File.file_name(),
      upload: "content",
      plaintiffs: [Faker.Person.name()],
      defendants: [Faker.Person.name()]
    }
  end
end
