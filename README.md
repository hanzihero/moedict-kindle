## Requisites

For Mac, must install Kindle Previewer 3 as this contains `kindlegen` needed for generating the mobi file.

https://www.amazon.com/Kindle-Previewer/b?ie=UTF8&node=21381691011

## Building

1. Run `elixir moedict.exs` to generate `moedict.html`
2. Run `./kindlegen-mac.sh` to generate `moedict.mobi`. If not using Mac, you can simply get `kindlegen` directly and run `kindlegen -c2 moedict.opf`.

## Testing/verifying

1. Add `moedict.mobi` to the dictionaries folder in your Kindle.
2. Go to Settings > Languages and Dictionaries > Dictionaries
3. Configure MOEDICT to be the default for Chinese
4. Open up a Chinese-language book and try looking things up.

If you need a Chinese-language book to test it on, here's one in public domain: https://www.gutenberg.org/ebooks/24264

## Resources

https://github.com/verenablaschke/kindle-dict

https://kdp.amazon.com/en_US/help/topic/G2HXJS944GL88DNV#html

https://jakemccrary.com/blog/2020/11/11/creating-a-custom-kindle-dictionary/
