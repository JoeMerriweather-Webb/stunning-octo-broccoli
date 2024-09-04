defmodule App.Documents.Extractor do
  @moduledoc """
  The main function, extract_data/1 attempts to extract plaintiffs and
  defendents from XML files. It first extracts every piece of textual data from
  the XML, and flattens it into a list of "lines". Some sanitizing of the data
  is attempted, such as removing line numbers.

  The function then attempts to find the "versus" line, which typically
  separates the plaintiffs (above) from the defendants (below). The plaintiffs
  were difficult to parse out from one of the sample XMLs, so it also checks
  lower down in the document for the plaintiffs.
  """

  def extract_data(upload) do
    upload
    # get the text for all of the "formatting" elements
    |> SweetXml.parse()
    |> extract_all_text([])
    |> List.flatten()
    |> find_data([])
  end

  defp extract_all_text(
         {:xmlElement, _name, _expanded_name, _nsinfo, _namespace, _parents, _pos, _attributes,
          [], _language, _xmlbase, _elementdef},
         all_text
       ) do
    all_text
  end

  defp extract_all_text({:xmlText, _parents, _pos, _attributes, text, :text}, all_text) do
    text = text |> List.to_string() |> String.trim()

    if text not in ["", nil] do
      [text | all_text]
    else
      all_text
    end
  end

  defp extract_all_text(
         {:xmlElement, _name, _expanded_name, _nsinfo, _namespace, _parents, _pos, _attributes,
          content, _language, _xmlbase, _elementdef},
         all_text
       ) do
    Enum.reduce(content, all_text, fn element, acc ->
      [Enum.reverse(extract_all_text(element, [])) | acc]
    end)
  end

  # didn't find a versus line
  defp find_data([], _lines_above) do
    %{plaintiffs: [], defendants: []}
  end

  defp find_data([line | lines_below], lines_above) do
    if versus_line?(line) do
      plaintiffs = find_plaintiffs_above_versus(lines_above, [])

      plaintiffs =
        if Enum.empty?(plaintiffs),
          do: find_plaintiffs_below_versus(lines_below, []),
          else: plaintiffs

      defendants = find_defendants_below_versus(lines_below, [])
      %{plaintiffs: plaintiffs, defendants: defendants}
    else
      find_data(lines_below, [line | lines_above])
    end
  end

  defp versus_line?(line), do: Regex.match?(~r/(v|vs)\./s, line)

  defp find_plaintiffs_above_versus([], plaintiffs) do
    plaintiffs
  end

  defp find_plaintiffs_above_versus([line | lines], plaintiffs) do
    if plaintiff = Regex.named_captures(~r/(?<plaintiff>.*)an individual/s, line)["plaintiff"] do
      plaintiff =
        plaintiff
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.join(" ")
        |> String.trim_trailing(",")

      find_plaintiffs_above_versus(lines, [plaintiff | plaintiffs])
    else
      find_plaintiffs_above_versus(lines, plaintiffs)
    end
  end

  defp find_plaintiffs_below_versus([], plaintiffs) do
    plaintiffs
  end

  defp find_plaintiffs_below_versus([line | lines], plaintiffs) do
    if plaintiff =
         Regex.named_captures(~r/Plaintiff\s(?<plaintiff>[a-zA-Z]+\s[a-zA-Z]+)\s+is/s, line)[
           "plaintiff"
         ] do
      find_plaintiffs_below_versus(lines, [plaintiff | plaintiffs])
    else
      find_plaintiffs_below_versus(lines, plaintiffs)
    end
  end

  defp find_defendants_below_versus([], _defendants_lines) do
    []
  end

  defp find_defendants_below_versus([line | lines], defendants_lines) do
    if Regex.match?(~r/defendants./si, line) do
      defendants_lines
      |> Enum.reverse()
      # remove lines that don't have letters, such as line numbers, only punctuation
      |> Enum.filter(&Regex.match?(~r/[a-zA-Z]/, &1))
      # general text clean up
      |> Enum.join(" ")
      |> String.split(" ", trim: true)
      |> Enum.map(&String.trim/1)
      # remove standalone characters that are generally either used as
      # separators, or seen as separators by OCR
      |> Enum.reject(&(&1 in ["i", "j", ")"]))
      |> Enum.join(" ")
      |> split_defendants()
      # clean up text for each defendant
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&Enum.map(&1, fn string -> String.trim(string) end))
      |> Enum.map(&Enum.join(&1, " "))
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.trim_trailing(&1, ","))
      |> Enum.map(&String.trim_trailing(&1, "."))
      |> Enum.map(&String.trim/1)
    else
      find_defendants_below_versus(lines, [line | defendants_lines])
    end
  end

  defp split_defendants(defendent_text) do
    cond do
      String.contains?(defendent_text, "; and") ->
        String.split(defendent_text, "; and")

      # DOES is a common start of a defendant, e.g. DOES 1 through 100, inclusive
      String.contains?(defendent_text, ", DOES") ->
        [first, second] = String.split(defendent_text, ", DOES", parts: 2)
        [first, "DOES " <> second]

      true ->
        List.wrap(defendent_text)
    end
  end
end
