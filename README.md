[![Build Status](https://travis-ci.org/1Poema/look-in-tens.svg?branch=master)](https://travis-ci.org/1Poema/look-in-tens)

# Look in Tens

By typing a public company’s name or stock ticker in a search box, instantaneously get its [PE10](http://www.investopedia.com/terms/p/pe10ratio.asp).

Visit the development website: http://www.lookintens.com.

## Development

Please, use [.editorconfig](http://editorconfig.org/).

### External Dependencies

* [Elixir](http://elixir-lang.org/)
* [Phoenix](http://www.phoenixframework.org/)
* [Postgres](http://www.postgresql.org/)

### Install and Run

1. From your app directory in the terminal, install dependencies with `mix deps.get`
2. Create database with `mix ecto.create`
3. Migrate database with `mix ecto.migrate`
4. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

### Seed

1. Run `iex -S mix`
2. Run `Dez.CompanyController.scrape`
(this will be moved to a worker soon)

Now you can visit `localhost:4000/companies` and see data in your browser.
