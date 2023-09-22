defmodule LinkShortener.LinksTest do
  use LinkShortener.DataCase

  alias LinkShortener.Links

  describe "links" do
    alias LinkShortener.Links.Link

    import LinkShortener.LinksFixtures

    @invalid_attrs %{"url" => "not-a-url"}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{"url" => "http://example.com", "hit_counter" => 42}

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      # assert link.key == "some key"
      assert link.url == "http://example.com"
      assert link.hit_counter == 42
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        "key" => link.key,
        "url" => "http://example-updated.com",
        "hit_counter" => 43
      }

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)

      assert link.url == "http://example-updated.com"
      assert link.hit_counter == 43
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end

    test "increase_hit_counter/1 increases hit counter value by 1" do
      link = link_fixture(%{"hit_counter" => 0})

      assert {:ok, %Link{} = link} = Links.increase_hit_counter(link)
      assert link.hit_counter == 1
    end
  end
end
