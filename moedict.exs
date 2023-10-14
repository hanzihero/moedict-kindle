Mix.install([:jason])

kindlegen_path = "/Applications/Kindle Previewer 3.app/Contents/lib/fc/bin//kindlegen"

if !File.exists?(kindlegen_path) do
  raise("kindlegen not found at #{kindlegen_path}")
end

# this is needed if using a.txt directly
# clean = fn s ->
#   String.replace(s || "", ["~", "`"], "")
# end

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
              examples: d["e"],
              quotes: d["q"]
            }
          end)
      }
    end)
  end)

html = EEx.eval_file("moedict.html.eex", entries: entries)
File.write!("moedict.html", html)

IO.puts("Finished generating moedict.html")
IO.puts("Running kindlegen")

System.cmd(kindlegen_path, ["-c0", "moedict.opf"], into: IO.stream())
