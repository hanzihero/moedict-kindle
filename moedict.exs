Mix.install([:jason])

# this is needed if using a.txt directly
# clean = fn s ->
#   String.replace(s || "", ["~", "`"], "")
# end

IO.puts("Processing entries in a-clean.txt")

entries =
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

IO.puts("Generating moedict.html")
html = EEx.eval_file("moedict.html.eex", entries: entries)
File.write!("moedict.html", html)
