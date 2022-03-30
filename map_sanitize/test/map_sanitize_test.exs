defmodule MapSanitizeTest do
  use ExUnit.Case

  test "returns input when not a map" do
    assert MapSanitize.scrub(1) == 1
    assert MapSanitize.scrub("string") == "string"
    assert MapSanitize.scrub(true) == true
    assert MapSanitize.scrub([]) == []
  end

  test "does not scrub keys that are not name, username, password or email" do
    assert MapSanitize.scrub(%{id: 1}) === %{id: 1}
    assert MapSanitize.scrub(%{"id" => 1}) === %{"id" => 1}
  end

  test "combined map input with diverse keys and values" do
    assert MapSanitize.scrub(%{
             id: 1,
             name: "jim",
             email: "jim@email.com",
             password: "hunter2",
             fav_fruit: "apple",
             friends: [
               %{name: "tom", pets_name: "doggo"},
               %{name: "alice", pets_name: "tacocat"}
             ]
           }) === %{
             id: 1,
             name: "********",
             email: "********@email.com",
             password: "********",
             fav_fruit: "apple",
             friends: [
               %{name: "********", pets_name: "doggo"},
               %{name: "********", pets_name: "tacocat"}
             ]
           }

    assert MapSanitize.scrub(%{
             "id" => 1,
             "name" => "jim",
             "email" => "jim@email.com",
             "password" => "hunter2",
             "fav_fruit" => "apple",
             "friends" => [
               %{"name" => "tom", "pets_name" => "doggo"},
               %{"name" => "alice", "pets_name" => "tacocat"}
             ]
           }) === %{
             "id" => 1,
             "name" => "********",
             "email" => "********@email.com",
             "password" => "********",
             "fav_fruit" => "apple",
             "friends" => [
               %{"name" => "********", "pets_name" => "doggo"},
               %{"name" => "********", "pets_name" => "tacocat"}
             ]
           }
  end

  test "scrubs name key" do
    assert MapSanitize.scrub(%{name: "jim"}) === %{name: "********"}
    assert MapSanitize.scrub(%{"name" => "jim"}) === %{"name" => "********"}

    assert MapSanitize.scrub(%{
             foo: %{bar: %{baz: %{name: "jim"}}}
           }) === %{
             foo: %{bar: %{baz: %{name: "********"}}}
           }

    assert MapSanitize.scrub(%{
             "foo" => %{"bar" => %{"baz" => %{"name" => "jim"}}}
           }) === %{
             "foo" => %{"bar" => %{"baz" => %{"name" => "********"}}}
           }
  end

  test "when name key is a map" do
    assert MapSanitize.scrub(%{
             name: %{name: "jim"}
           }) === %{
             name: %{name: "********"}
           }
  end

  test "when name key is a list" do
    assert MapSanitize.scrub(%{
             name: [%{name: "jim"}]
           }) === %{
             name: [%{name: "********"}]
           }
  end

  test "scrubs username key" do
    assert MapSanitize.scrub(%{username: "jim_username"}) === %{username: "********"}
    assert MapSanitize.scrub(%{"username" => "jim_username"}) === %{"username" => "********"}

    assert MapSanitize.scrub(%{
             foo: %{bar: %{baz: %{username: "jim_username"}}}
           }) === %{
             foo: %{bar: %{baz: %{username: "********"}}}
           }

    assert MapSanitize.scrub(%{
             "foo" => %{"bar" => %{"baz" => %{"username" => "jim_username"}}}
           }) === %{
             "foo" => %{"bar" => %{"baz" => %{"username" => "********"}}}
           }
  end

  test "when username key is a map" do
    assert MapSanitize.scrub(%{
             username: %{username: "jim_username"}
           }) === %{
             username: %{username: "********"}
           }
  end

  test "when username key is a list" do
    assert MapSanitize.scrub(%{
             username: [%{username: "jim_username"}]
           }) === %{
             username: [%{username: "********"}]
           }
  end

  test "scrubs password key" do
    assert MapSanitize.scrub(%{password: "hunter2"}) === %{password: "********"}
    assert MapSanitize.scrub(%{"password" => "hunter2"}) === %{"password" => "********"}

    assert MapSanitize.scrub(%{
             foo: %{bar: %{baz: %{password: "hunter2"}}}
           }) === %{
             foo: %{bar: %{baz: %{password: "********"}}}
           }

    assert MapSanitize.scrub(%{
             "foo" => %{"bar" => %{"baz" => %{"password" => "hunter2"}}}
           }) === %{
             "foo" => %{"bar" => %{"baz" => %{"password" => "********"}}}
           }
  end

  test "when password key is a map" do
    assert MapSanitize.scrub(%{
             password: %{password: "hunter2"}
           }) === %{
             password: %{password: "********"}
           }
  end

  test "when password key is a list" do
    assert MapSanitize.scrub(%{
             password: [%{password: "hunter2"}]
           }) === %{
             password: [%{password: "********"}]
           }
  end

  test "scrubs email key" do
    assert MapSanitize.scrub(%{email: "jim@email.com"}) === %{email: "********@email.com"}
    assert MapSanitize.scrub(%{"email" => "jim@email.com"}) === %{"email" => "********@email.com"}

    assert MapSanitize.scrub(%{
             foo: %{bar: %{baz: %{email: "jim@email.com"}}}
           }) === %{
             foo: %{bar: %{baz: %{email: "********@email.com"}}}
           }

    assert MapSanitize.scrub(%{
             "foo" => %{"bar" => %{"baz" => %{"email" => "jim@email.com"}}}
           }) === %{
             "foo" => %{"bar" => %{"baz" => %{"email" => "********@email.com"}}}
           }
  end

  test "when email key is a map" do
    assert MapSanitize.scrub(%{
             email: %{email: "jim@email.com"}
           }) === %{
             email: %{email: "********@email.com"}
           }
  end

  test "when email key is a list" do
    assert MapSanitize.scrub(%{
             email: [%{email: "jim@email.com"}]
           }) === %{
             email: [%{email: "********@email.com"}]
           }
  end

  test "when email does not contain @" do
    assert MapSanitize.scrub(%{
             email: "jim_at_email_dot_com"
           }) === %{
             email: "jim_at_email_dot_com"
           }

    assert MapSanitize.scrub(%{
             "email" => "jim_at_email_dot_com"
           }) === %{
             "email" => "jim_at_email_dot_com"
           }
  end
end
