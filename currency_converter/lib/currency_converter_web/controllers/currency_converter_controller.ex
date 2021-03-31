defmodule CurrencyConverterWeb.CurrencyController do
  use CurrencyConverterWeb, :controller

  def index(conn, %{"from" => from, "to" => to, "amount" => amount}) do
    case Float.parse(amount) do
      :error ->
        json(conn, %{success: false, message: "Please provide amount as integer or float"})

      {parsed_amount, _} ->
        to_up = String.upcase(to)
        url = "https://api.ratesapi.io/api/latest?base=#{String.upcase(from)}&symbols=#{to_up}"

        with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url),
             %{"rates" => to_rates} <- Poison.decode!(body),
             exchange_rate <- Map.get(to_rates, to_up) do
          converted_amount = Float.round(parsed_amount * exchange_rate, 2)

          json(conn, %{
            success: true,
            input: %{from: from, to: to, amount: amount},
            exchange_rate: exchange_rate,
            output: converted_amount
          })
        else
          %{"error" => error} ->
            json(conn, %{success: false, message: error})

          _ ->
            json(conn, %{success: false, message: "Something went wrong"})
        end
    end
  end

  def index(conn, _params) do
    json(conn, %{
      success: false,
      message: "Please provide parameters for conversion: `from`, `to`, and `amount`"
    })
  end
end
