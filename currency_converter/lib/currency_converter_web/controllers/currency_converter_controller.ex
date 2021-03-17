defmodule CurrencyConverterWeb.CurrencyController do
  use CurrencyConverterWeb, :controller

  def index(conn, _params) do
    json(conn, %{success: true})
  end
end
