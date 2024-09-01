defmodule App.Documents.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :filename, :string
    field :content_type, :string
    field :upload, :binary
    field :plaintiffs, {:array, :string}, default: []
    field :defendants, {:array, :string}, default: []

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

  def wrap_changeset(%{valid?: true} = changeset), do: {:ok, changeset}
  def wrap_changeset(%{valid?: false} = changeset), do: {:error, changeset}
end
