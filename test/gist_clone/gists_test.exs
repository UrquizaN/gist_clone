defmodule GistClone.GistsTest do
  use GistClone.DataCase

  alias GistClone.Gists

  import GistClone.AccountsFixtures

  setup do
    user = user_fixture()
    %{user: user}
  end

  describe "gists" do
    alias GistClone.Gists.Gist

    import GistClone.GistsFixtures

    @invalid_attrs %{name: nil, description: nil, markup_text: nil}

    test "list_gists/0 returns all gists", %{user: user} do
      gist = gist_fixture(user: user)
      assert Gists.list_gists(user) == [gist]
    end

    test "get_gist!/1 returns the gist with given id" do
      gist = gist_fixture()
      assert Gists.get_gist!(gist.id) == gist
    end

    test "create_gist/1 with valid data creates a gist", %{user: user} do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        markup_text: "some markup_text"
      }

      assert {:ok, %Gist{} = gist} = Gists.create_gist(user, valid_attrs)
      assert gist.name == "some name"
      assert gist.description == "some description"
      assert gist.markup_text == "some markup_text"
    end

    test "create_gist/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Gists.create_gist(user, @invalid_attrs)
    end

    test "update_gist/2 with valid data updates the gist", %{user: user} do
      gist = gist_fixture(user: user)

      update_attrs = %{
        id: gist.id,
        name: "some updated name",
        description: "some updated description",
        markup_text: "some updated markup_text"
      }

      assert {:ok, %Gist{} = gist} = Gists.update_gist(user, update_attrs)
      assert gist.name == "some updated name"
      assert gist.description == "some updated description"
      assert gist.markup_text == "some updated markup_text"
    end

    test "update_gist/2 with invalid data returns error changeset", %{user: user} do
      gist = gist_fixture(user: user)

      assert {:error, %Ecto.Changeset{}} =
               Gists.update_gist(user, Map.merge(@invalid_attrs, %{id: gist.id}))

      assert gist == Gists.get_gist!(gist.id)
    end

    test "delete_gist/1 deletes the gist", %{user: user} do
      gist = gist_fixture(user: user)
      assert {:ok, %Gist{}} = Gists.delete_gist(user, gist.id)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_gist!(gist.id) end
    end

    test "change_gist/1 returns a gist changeset", %{user: user} do
      gist = gist_fixture(user: user)
      assert %Ecto.Changeset{} = Gists.change_gist(gist)
    end
  end

  describe "saved_gists" do
    alias GistClone.Gists.SavedGist

    import GistClone.GistsFixtures

    @invalid_attrs %{}

    test "list_saved_gists/0 returns all saved_gists", %{user: user} do
      saved_gist = saved_gist_fixture(user: user)
      assert Gists.list_saved_gists(user) == [saved_gist]
    end

    test "get_saved_gist!/1 returns the saved_gist with given id" do
      saved_gist = saved_gist_fixture()
      assert Gists.get_saved_gist!(saved_gist.id) == saved_gist
    end

    test "create_saved_gist/1 with valid data creates a saved_gist", %{user: user} do
      gist = gist_fixture(user: user)

      assert {:ok, %SavedGist{} = _saved_gist} =
               Gists.create_saved_gist(user, %{gist_id: gist.id})
    end

    test "create_saved_gist/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Gists.create_saved_gist(user, @invalid_attrs)
    end

    test "update_saved_gist/2 with valid data updates the saved_gist" do
      saved_gist = saved_gist_fixture()
      update_attrs = %{}

      assert {:ok, %SavedGist{} = _saved_gist} = Gists.update_saved_gist(saved_gist, update_attrs)
    end

    test "update_saved_gist/2 with invalid data returns error changeset", %{user: user} do
      saved_gist = saved_gist_fixture(user: user)

      assert {:error, %Ecto.Changeset{}} =
               Gists.update_saved_gist(saved_gist |> Map.delete(:user_id), @invalid_attrs)

      assert saved_gist == Gists.get_saved_gist!(saved_gist.id)
    end

    test "delete_saved_gist/1 deletes the saved_gist", %{user: user} do
      gist = gist_fixture(user: user)
      saved_gist = saved_gist_fixture(gist: gist, user: user)
      assert {:ok, %SavedGist{}} = Gists.delete_saved_gist(user, gist.id)
      assert_raise Ecto.NoResultsError, fn -> Gists.get_saved_gist!(saved_gist.id) end
    end

    test "delete_saved_gist/1 returns error when the user has no access to the saved_gist", %{
      user: user
    } do
      gist = gist_fixture()
      saved_gist_fixture(user: user)
      assert {:error, :unauthorized} = Gists.delete_saved_gist(user, gist.id)
    end

    test "change_saved_gist/1 returns a saved_gist changeset" do
      saved_gist = saved_gist_fixture()
      assert %Ecto.Changeset{} = Gists.change_saved_gist(saved_gist)
    end
  end
end
