defmodule GistClone.GistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `GistClone.Gists` context.
  """

  import GistClone.AccountsFixtures

  @doc """
  Generate a gist.
  """
  def gist_fixture(attrs \\ %{}) do
    user = attrs[:user] || user_fixture()

    attrs =
      Enum.into(attrs, %{
        description: "some description",
        markup_text: "some markup_text",
        name: "some name"
      })

    {:ok, gist} = GistClone.Gists.create_gist(user, attrs)

    gist
  end

  @doc """
  Generate a saved_gist.
  """
  def saved_gist_fixture(attrs \\ %{}) do
    user = attrs[:user] || user_fixture()
    gist = attrs[:gist] || gist_fixture(user: user)

    attrs =
      Enum.into(attrs, %{
        gist_id: gist.id
      })

    {:ok, saved_gist} = GistClone.Gists.create_saved_gist(user, attrs)

    saved_gist
  end
end
