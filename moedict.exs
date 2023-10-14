kindlegen_path = "/Applications/Kindle Previewer 3.app/Contents/lib/fc/bin//kindlegen"

if !File.exists?(kindlegen_path) do
  raise("kindlegen not found at #{kindlegen_path}")
end

entries = [
  %{
    headword: "你",
    pinyin: "nǐ"
  }
]

html = EEx.eval_file("moedict.html.eex", entries: entries)
File.write!("moedict.html", html)

IO.puts("hi")
System.cmd(kindlegen_path, ["-c0", "-verbose", "moeadict.opf"])
