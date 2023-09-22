# LinkShortener

## Get started -

### Install needed language versions

Run correct versions of elixir, erlang and nodejs

I use [asdf](https://asdf-vm.com/) as a version manager. If you don't have it, please either install it locally OR reference [.tool-versions](./tool-versions) to install the correct versions.

Once you have asdf installed run the following command:

```bash
asdf install
```

### Install same phoenix version

Per the documentation in https://github.com/phoenixframework/archives , run the following command:

```bash
mix archive.install hex phx_new 1.7.7
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

## Running local tests

```bash
mix test
```

## Criteria

- When navigating to the root path (e.g. http://localhost:8080/) of the app in a browser a user should be presented with a form that allows them to paste in a URL (e.g. https://www.google.com/search?q=url+shortener&oq=google+u&aqs=chrome.0.69i59j69i60l3j0j69i57.1069j0j7&sourceid=chrome&ie=UTF-8).
- When a user submits the form they should be presented with a simplified URL of the form http://localhost:8080/{slug} (e.g. http://localhost:8080/h40Xg2). The format and method of generation of the slug is up to your discretion.
- When a user navigates to a shortened URL that they have been provided by the app (e.g. http://localhost:8080/h40Xg2) they should be redirected to the original URL that yielded that short URL (e.g https://www.google.com/search?q=url+shortener&oq=google+u&aqs=chrome.0.69i59j69i60l3j0j69i57.1069j0j7&sourceid=chrome&ie=UTF-8).
- Only allow valid URLs (e.g., start with http(s)://{domain}/ )
- When a user navigates to `/stats` they should be presented with a basic table that lists each shortened url, its corresponding original url, and the number of times a user has visited the shortened url. From this page, the user should also be able to download a CSV of the data contained in the table.

## Future enhancements

- how to throttle requests (botting safe guard)
   - prob add some fingerprinting and then rate limit on that
- adding depricated field to `Link` to allow keys to be used again
- allowing users to define key
- user auth
   - https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Auth.html
- linking users to links
   - add one to many table `user_links` with a Link.ex > belongs_to(:user)
   - use context with user id to verify user can see that users links? think about permissioning

## Project thoughts

- I used the default phoenix / tailwind styling and generators for the majority of the work.
- Overall a very straight forward challenge. I hope you enjoy my submission.
