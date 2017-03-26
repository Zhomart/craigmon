# Craigslist Monitor

Monitors craigslist items.

## Features

- Web UI
- Worker that fetches data from craigslist

## Used

- Web: Kemal
- DB: sqlite3
- JS: riotjs
- CSS: http://bulma.io

## TODO

- [x] UI: Accept a craigslist search url to process and store in DB
- [x] Worker: Download url from craigslist every N seconds and store results in DB
- [x] Worker: crawl multiple pages
- [x] UI: Show results
- [x] UI: pagination
- [x] UI: auth
- [ ] UI: vanished filter

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

**Building** `$ make build`

**My thoughts on Crystal**

- Crystal doesn't have embedding debuggers, e.g. `pry`, `binding.irb` or `IPython.embed`
- Just found interactive crystal `icr` https://github.com/greyblake/crystal-icr
- Language is addicting.
- No code reloading. Always have to restart the app.
- Blazingly fast.
- OptionParser is too simple.
- Crystal doesn't have my loved `Pathname` from ruby.
- Kemal's router is really simple.
- Couldn't make XML's `xpath` work for RSS.


## Contributing

1. Fork it ( https://github.com/[your-github-name]/craig_mon/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) Zhomart Mukhamejanov - creator, maintainer
