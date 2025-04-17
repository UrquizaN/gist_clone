defmodule GistClone.CommentsTest do
  use GistClone.DataCase

  alias GistClone.Comments

  describe "comments" do
    alias GistClone.Comments.Comment

    import GistClone.CommentsFixtures
    import GistClone.AccountsFixtures
    import GistClone.GistsFixtures

    @invalid_attrs %{markup_text: nil}

    setup do
      user = user_fixture()
      gist = gist_fixture(user: user)
      %{user: user, gist: gist}
    end

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment", %{user: user, gist: gist} do
      valid_attrs = %{markup_text: "some markup_text", gist_id: gist.id}

      assert {:ok, %Comment{} = comment} = Comments.create_comment(user, valid_attrs)
      assert comment.markup_text == "some markup_text"
    end

    test "create_comment/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Comments.create_comment(user, @invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment", %{user: user, gist: gist} do
      comment = comment_fixture(user: user, gist: gist)
      update_attrs = %{markup_text: "some updated markup_text"}

      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, update_attrs)
      assert comment.markup_text == "some updated markup_text"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
