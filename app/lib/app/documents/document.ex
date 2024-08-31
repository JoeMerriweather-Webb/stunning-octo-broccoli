defmodule App.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :filename, :string
    field :content_type, :string
    field :upload, :binary
    field :plaintiffs, {:array, :string}
    field :defendants, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:filename, :content_type, :upload, :plaintiffs, :defendants])
    |> validate_required([
      :filename,
      :content_type,
      :upload,
      :plaintiffs,
      :defendants
    ])
  end
end
