defmodule CurrencyConverterWeb.CurrencyController do
  use CurrencyConverterWeb, :controller

  def index(conn, %{"from" => from, "to" => to, "amount" => amount} = params) do
    json(conn, %{success: true})
  end

  def index(conn, _params) do
    json(conn, %{
      success: false,
      message: "Please provide parameters for conversion: `from`, `to`, and `amount`"
    })
  end
end
