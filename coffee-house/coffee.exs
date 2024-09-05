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

# jim flow
# 1. when open, create employee queues: baristaqueue and runnerqueue
# 2. when take order is called, use runner queue
#   a. when order is finished send to barista queue to make
# 3. when item in barista queue, use barista
#   a. when barista is made, send to runner queue
#   b. if runner is not taking an order, they can run the existing order

defmodule CoffeeHouse do
  def open() do
    IO.puts("CoffeeHouse is now open!")

    # Spawn the barista process to be used throughout the day
    barista_task = Task.async(fn -> barista_loop() end)

    # Spawn the runner process to be used throughout the day
    runner_task = Task.async(fn -> runner_loop() end)

    # Return tasks
    %{barista_task: barista_task, runner_task: runner_task, tasks: []}
  end

  def close(%{
        barista_task: %{pid: barista_pid} = barista_task,
        runner_task: %{pid: runner_pid} = runner_task,
        tasks: tasks
      }) do
    # Wait for all runner tasks to finish
    Enum.each(tasks, &Task.await(&1, :infinity))

    # Tell the barista to stop after all orders are completed
    send(barista_pid, :stop)

    # Wait for barista to finish all brewing
    IO.puts("Waiting for the barista to finish...")
    Task.await(barista_task, :infinity)

    # Notify and wait for the runner to finish all deliveries
    send(runner_pid, :stop)

    IO.puts("Waiting for the runner to finish...")
    Task.await(runner_task, :infinity)

    IO.puts("CoffeeHouse is now closed!")
  end

  def take_order(
        customer,
        order,
        %{barista_task: %{pid: barista_pid}, runner_task: %{pid: runner_pid}, tasks: tasks} =
          state
      ) do
    # Spawn a new task for each order
    task =
      Task.async(fn ->
        # Take the order
        IO.puts("Runner is taking order from #{customer}")
        # Simulate time to take the order
        :timer.sleep(1000)

        # Send the order to the barista
        send(barista_pid, {:brew, runner_pid, customer, order})
      end)

    # Add the new task to the list of tasks
    %{state | tasks: [task | tasks]}
  end

  defp runner_loop() do
    receive do
      {:order_ready, customer, order} ->
        IO.puts("Runner received order ready message for #{customer}: #{inspect(order)}")
        deliver_order(customer, order)
        runner_loop()

      :stop ->
        IO.puts("Runner is done for the day!")
        :ok
    end
  end

  defp deliver_order(customer, order) do
    IO.puts("Runner is delivering coffee #{inspect(order)} to #{customer}")
    # Simulate time to deliver the order
    :timer.sleep(1000)
  end

  defp barista_loop() do
    receive do
      {:brew, runner, customer, orders} ->
        IO.puts("Barista is brewing coffee for #{customer}: #{inspect(orders)}")
        brew_coffee(customer, orders)

        # Notify the runner that the order is ready
        send(runner, {:order_ready, customer, orders})

        # Continue processing future orders
        barista_loop()

      :stop ->
        IO.puts("Barista is done for the day!")
        # Barista stops when receiving the stop signal
        :ok
    end
  end

  defp brew_coffee(customer, orders) do
    Enum.each(orders, fn order ->
      IO.puts("Barista is brewing coffee #{order} for #{customer}")
      # Simulate time to brew coffee
      :timer.sleep(1000)
    end)
  end
end

# Usage
state = CoffeeHouse.open()
state = CoffeeHouse.take_order("foo", 1..3, state)
state = CoffeeHouse.take_order("bar", 4..6, state)

# Make sure all orders are processed before closing
CoffeeHouse.close(state)
