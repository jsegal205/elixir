# CurrencyConverter

A simple JSON endpoint that calculates exchange rate of a given currency.

## Run Project

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

### Sample Request
```
http://localhost:4000/?from=EUR&to=USD&amount=123
```

### Controller
[lib/currency_converter_web/controllers/currency_converter_controller.ex](lib/currency_converter_web/controllers/currency_converter_controller.ex)


### Uses
- HTTPoison for web requests
- https://ratesapi.io/ for current exchange rate data


## Tests
[test/currency_converter_web/controllers/currency_converter_controller_test.exs](test/currency_converter_web/controllers/currency_converter_controller_test.exs)

Run tests with
```
mix test
```

## mix phx.new readme boilerplate

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
