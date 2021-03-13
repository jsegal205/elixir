# LiveViewCounter

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

## Tutorial

Followed https://github.com/dwyl/phoenix-liveview-counter-tutorial

## Learnings

- Live view controllers named with a suffix of `live` get some magic applied to them for routing to the action

From the CLI

```
** (ArgumentError) could not infer :as option because a live action was given and the LiveView does not have a "Live" suffix. Please pass :as explicitly or make sure your LiveView is named like "FooLive" or "FooLive.Index"
```

More reading:
https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.Router.html#live/4

- [assign/3](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html?#assign/3) will also create a template variable if an atom is given

`assign(socket, :count, 0)` can be read back either as `assigns[:count]` or `@count`
