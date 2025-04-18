defmodule GistClone.Repo.Migrations.AddUniqueIndexSavedGist do
  use Ecto.Migration

  def change do
    create unique_index(:saved_gists, [:user_id, :gist_id])
  end
end
