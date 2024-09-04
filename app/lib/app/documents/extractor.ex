defmodule App.Documents.Extractor do
  import SweetXml

  @moduledoc """
  The main function, extract_data/1 attempts to extract plaintiffs and
  defendents from XML files. This currently only works with somewhat similarly
  formatted XMLs, with the text in <formatting> tags. With more relevant sample
  XMLs, it could be expanded to work with differently structured XMLs.

  The function first attempts to find the "versus" line, which typically
  separates the plaintiffs (above) from the defendants (below). The plaintiffs
  were difficult to parse out from one of the sample XMLs, so it also checks
  lower down in the document for the plaintiffs.
  """

  def extract_data(upload) do
    upload
    # get the text for all of the "formatting" elements
    |> SweetXml.xpath(~x"//formatting/text()"l)
    |> Enum.map(fn line -> line |> List.to_string() |> String.trim() end)
    |> find_data([])
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
      # remove line numbers, extra punctuation
      |> Enum.reject(&(String.length(&1) <= 2))
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
