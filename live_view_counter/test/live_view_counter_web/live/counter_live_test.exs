defmodule LiveViewCounterWeb.CounterLiveTest do
  use LiveViewCounterWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, counter_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "The count is 0"
    assert render(counter_live) =~ "The count is 0"
  end
end
