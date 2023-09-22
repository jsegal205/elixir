defmodule LinkShortenerWeb.LinkRedirectController do
  use LinkShortenerWeb, :controller

  alias LinkShortener.Links
  alias LinkShortener.Links.Link

  def index(conn, %{"key" => key}) do
    case Links.get_link_by_key(key) do
      %Link{url: url} ->
        redirect(conn, external: url)

      _ ->
        conn
        |> put_flash(:error, "Link doesn't exist, please create one!")
        |> redirect(to: "/")
    end
  end
end
