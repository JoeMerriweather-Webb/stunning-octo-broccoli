defmodule App.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :upload, :binary
      add :content_type, :string
      add :filename, :string
      add :plaintiffs, {:array, :string}
      add :defendants, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
