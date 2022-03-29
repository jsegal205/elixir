# MapCompare

## Description

Creating a library for comparing two maps passed as arguements.

### Qualifications

- Map only have string keys
- Map only have string, boolean, number, list or map as value
- Compare should have an option for deep or shallow compare
- Compare should list the difference for keys and values

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
iex(1)> MapCompare.compare(1, 2)
{:error, "Invalid arg type. Only accepts Maps as args."}

iex(2)> MapCompare.compare(%{}, %{})
%{same: true}
```
