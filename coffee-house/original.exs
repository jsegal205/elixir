### SETUP
# Current coffeehouse has one employee, they take orders, make orders and deliver those orders to patreons.
# Business is booming, and we decide to hire another employee giving us a barista and a cashier / runner.

# how can we set up a coffehouse api that will run concurrently for the two employees?

# flow in specific order:
# take order then make order then run order

# rules
# coffee house only sells one type of coffee and a customer can order one or many of this coffee
# only the runner employee can take orders and deliver orders
# only the barista can make the orders
# the runner has to be cannot deliver an order and also take an order
# all orders must be completed and delivered before the shop can close

defmodule CoffeeHouse do
  def open() do
    IO.puts("CoffeeHouse is now open!")
    :ok
  end

  def close() do
    IO.puts("CoffeeHouse is now closed!")
    :ok
  end

  def take_order(customer, order) do
    IO.puts("Only employee is taking order for #{customer}")
    # simulate time to take order
    :timer.sleep(1000)

    brew_coffee(customer, order)
  end

  defp brew_coffee(customer, orders) do
    Enum.each(orders, fn order ->
      IO.puts("Only employee is brewing coffee #{order} for #{customer}")
      # simulate time to make order
      :timer.sleep(1000)
      run_order(customer, order)
    end)
  end

  defp run_order(customer, order) do
    IO.puts("Only employee is running coffee #{order} for #{customer}")
    # simulate time to deliver order
    :timer.sleep(1000)
  end
end

CoffeeHouse.open()
CoffeeHouse.take_order("foo", 1..3)
CoffeeHouse.take_order("bar", 4..6)
CoffeeHouse.close()
