# Craigslist Monitor

Monitors craigslist items.

## Features

- Web UI
- Worker that fetches data from craigslist

## TODO

- [x] UI: Accept a craigslist search url to process and store in DB
- [ ] Worker: Download url from craigslist every N seconds and store results in DB
- [ ] Worker: crawl all pages
- [ ] UI: Show results
- [ ] UI: auth

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

**Building** `$ make build`

**My thoughts on Crystal**

- Crystal doesn't have embedding debuggers, e.g. `pry`, `binding.irb` or `IPython.embed`
- Just found interactive crystal `icr` https://github.com/greyblake/crystal-icr
- No code reloading. Always have to restart the app.
- Sometimes doesn't feel like writing on static types language.
- But static typing makes feel more confident and safe.
- OptionParser is too simple.
- Crystal doesn't have my beloved `Pathname` from ruby.
- Kemal's router is really simple.
- Overall crystal app feels really fast.
- Couldn't make `xpath` to work for RSS.


## Contributing

1. Fork it ( https://github.com/[your-github-name]/craig_mon/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Zhomart Mukhamejanov - creator, maintainer
