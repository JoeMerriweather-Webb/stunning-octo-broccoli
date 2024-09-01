defmodule AppWeb.DocumentJSON do
  use JSONAPI.View, type: "documents"

  def fields, do: [:filename, :content_type, :plaintiffs, :defendants]
end
