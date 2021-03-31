defmodule CurrencyConverterWeb.CurrencyConverterControllerTest do
  use CurrencyConverterWeb.ConnCase, async: false
  import Mock

  describe "index" do
    test "missing all params", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index))

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide parameters for conversion: `from`, `to`, and `amount`"
             }
    end

    test "missing `to` param", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index), %{"from" => "USD", "amount" => "1"})

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide parameters for conversion: `from`, `to`, and `amount`"
             }
    end

    test "missing `from` param", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index), %{"to" => "USD", "amount" => "1"})

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide parameters for conversion: `from`, `to`, and `amount`"
             }
    end

    test "missing `amount` param", %{conn: conn} do
      conn = get(conn, Routes.currency_path(conn, :index), %{"to" => "USD", "from" => "EUR"})

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide parameters for conversion: `from`, `to`, and `amount`"
             }
    end

    test "invalid amount param", %{conn: conn} do
      conn =
        get(conn, Routes.currency_path(conn, :index), %{
          "to" => "USD",
          "from" => "EUR",
          "amount" => "invalid"
        })

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide amount as integer or float"
             }
    end

    test "blank amount param", %{conn: conn} do
      conn =
        get(conn, Routes.currency_path(conn, :index), %{
          "to" => "USD",
          "from" => "EUR",
          "amount" => ""
        })

      assert json_response(conn, 200) == %{
               "success" => false,
               "message" => "Please provide amount as integer or float"
             }
    end

    test "invalid `to` param", %{conn: conn} do
      conn =
        get(conn, Routes.currency_path(conn, :index), %{
          "to" => "USDA",
          "from" => "EUR",
          "amount" => "1"
        })

      response = json_response(conn, 200)
      assert response["success"] == false
      # probably shouldn't assert against third party api messaging, maybe should mock
      assert response["message"] =~ "'USDA' are invalid"
    end

    test "invalid `from` param", %{conn: conn} do
      conn =
        get(conn, Routes.currency_path(conn, :index), %{
          "to" => "USD",
          "from" => "EURA",
          "amount" => "1"
        })

      response = json_response(conn, 200)
      assert response["success"] == false
      # probably shouldn't assert against third party api messaging, maybe should mock
      assert response["message"] == "Base 'EURA' is not supported."
    end

    test "catchall error path", %{conn: conn} do
      with_mock(HTTPoison,
        get: fn _url ->
          {:error,
           %HTTPoison.Response{
             body: "{\"OHNO\": \"Critical error\" }"
           }}
        end
      ) do
        conn =
          get(conn, Routes.currency_path(conn, :index), %{
            "to" => "USD",
            "from" => "EUR",
            "amount" => "1"
          })

        assert json_response(conn, 200) == %{
                 "message" => "Something went wrong",
                 "success" => false
               }
      end
    end

    test "happy path", %{conn: conn} do
      with_mock(HTTPoison,
        get: fn _url ->
          {:ok,
           %HTTPoison.Response{
             body: "{\"rates\": {\"USD\": 2} }"
           }}
        end
      ) do
        conn =
          get(conn, Routes.currency_path(conn, :index), %{
            "to" => "USD",
            "from" => "EUR",
            "amount" => "1"
          })

        assert json_response(conn, 200) == %{
                 "exchange_rate" => 2,
                 "input" => %{"amount" => "1", "from" => "EUR", "to" => "USD"},
                 "output" => 2.0,
                 "success" => true
               }
      end
    end
  end
end
