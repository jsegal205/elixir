# LinkShortener

## Get started -

### Install needed language versions

Run correct versions of elixir, erlang and nodejs

I use [asdf](https://asdf-vm.com/) as a version manager. If you don't have it, please either install it locally OR reference [.tool-versions](./tool-versions) to install the correct versions.

Once you have asdf installed run the following command:

```bash
asdf install
```

### Set up project requirements

The following command will get elixir dependencies, set up the DB and install any needed UI related dependencies

```bash
mix setup
```

## Run local server

```bash
mix phx.server
```

or to run the server in an IEx session (good for debugging)

```bash
iex -S mix phx.server
```

Now you can visit [`localhost:8080`](http://localhost:8080) from your browser.
