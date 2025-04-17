defmodule GistClone.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GistClone.Comments` context.
  """

  import GistClone.AccountsFixtures
  import GistClone.GistsFixtures

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    user = user_fixture()
    gist = gist_fixture(user_id: user.id)

    attrs =
      Enum.into(attrs, %{
        markup_text: "some markup_text",
        user_id: user.id,
        gist_id: gist.id
      })

    {:ok, comment} = GistClone.Comments.create_comment(user, attrs)

    comment
  end
end
