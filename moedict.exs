entries = [
  %{
    headword: "你",
    pinyin: "nǐ"
  }
]

html = EEx.eval_file("moedict.html.eex", entries: entries)
File.write!("moedict.html", html)
