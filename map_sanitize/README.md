# MapSanitize

## Description

Creating a library for sanitizing potentially sensitive data that may be passed in as a source.

### Qualifications

- replace all "name", "username", and "password" values with the string "\*\*\*\*\*\*\*\*"
- for all "email" fields, replace only the username (the part before the @)
- data can be nested inside maps or lists at any depth.

## Setup

I use [asdf](https://asdf-vm.com/) to manage all of my dependencies.

Please use `asdf install` to install the correct versions of Elixir and Erlang. If you do not use asdf, please install the following versions:

```
elixir 1.13.3-otp-24
erlang 24.3.2
```

## Tests

Use the following command to run the test suite:

```bash
  mix test
```

## Running in terminal

To run and test the library in your terminal, use the following command:

```bash
  iex -S mix run
```

You can then also run commands against the module:

```elixir
iex(1)> MapSanitize.scrub(%{id: 1, name: "jim", email: "jim@email.com", username: "jim_username", password: "hunter2", pet_name: "doggo" })
%{
  email: "********@email.com",
  id: 1,
  name: "********",
  password: "********",
  pet_name: "doggo",
  username: "********"
}
```
