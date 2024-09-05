# Coffeehouse concurrency update

Current coffeehouse has one employee, they take orders, make orders and deliver those orders to patreons.
Business is booming, and we decide to hire another employee giving us a barista and a cashier / runner.

How can we set up a coffehouse api that will run concurrently for the two employees?

## Setup

Use [original.exs](original.exs) as starting point for code.

Flow of the coffeehouse in specific order:

1. take order
2. make order
3. run order

## Business rules

- coffee house only sells one type of coffee and a customer can order one or many of this coffee (order will be a list of integers)
- only the runner employee can take orders and deliver orders
- only the barista can make the orders
- the runner has to be cannot deliver an order and also take an order at the same time
- all orders must be completed and delivered before the shop can close

## Run

### Original code

Ensure that elixir is installed via your favorite language installer then run the following:

```sh
elixir original.exs
```

### Updated concurrent code

Ensure that elixir is installed via your favorite language installer then run the following:

```sh
elixir coffee.exs
```
