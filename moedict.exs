Mix.install([:jason])

# this is needed if using a.txt directly
# clean = fn s ->
#   String.replace(s || "", ["~", "`"], "")
# end

IO.puts("Processing entries in a-clean.txt")

entry_groups =
  File.stream!("a-clean.txt")
  |> Stream.filter(&(String.trim(&1) != ""))
  |> Stream.map(fn l ->
    [_, _, json] = String.split(l, " ", parts: 3)
    Jason.decode!(json)
  end)
  # |> Stream.filter(&(&1["t"] == "好"))
  |> Enum.flat_map(fn c ->
    Enum.map(c["h"], fn h ->
      %{
        char: c["t"],
        pinyin: h["p"],
        definitions:
          Enum.map(h["d"], fn d ->
            %{
              definition: d["f"],
              type: d["type"],
              examples: d["e"] || [],
              quotes: d["q"],
              synonyms: d["s"],
              antonyms: d["a"]
            }
          end)
      }
    end)
  end)
  |> Enum.chunk_every(1000)
  |> Enum.with_index()
  |> Enum.map(fn {entries, index} ->
    padded_index =
      index
      |> Integer.to_string()
      |> String.pad_leading(3, "0")

    {entries, padded_index}
  end)

IO.puts("Generating the moedict.html files")

Enum.each(entry_groups, fn {entries, index} ->
  html = EEx.eval_file("moedict.html.eex", entries: entries)
  File.write!("output/moedict#{index}.html", html)
end)

IO.puts("Generating moedict.opf file")

indexes =
  entry_groups
  |> Enum.map(fn {_entries, index} -> index end)

opf = EEx.eval_file("moedict.opf.eex", indexes: indexes)
File.write!("output/moedict.opf", opf)
